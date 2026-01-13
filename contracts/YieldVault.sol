// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Mocks.sol";

/// @title Yield Generating Vault
/// @notice A simplified implementation of a tokenized vault (ERC-4626 style).
/// @dev Users deposit USDC to receive vSHARE tokens representing their share of the pool.
contract YieldVault is ERC20 {
    IERC20 public immutable asset;
    MockLendingProtocol public immutable lendingProtocol;

    // Custom Errors for Gas Optimization
    error ZeroAssets();
    error ZeroShares();

    /// @param _asset The underlying asset (e.g., USDC) to be managed.
    /// @param _protocol The external lending protocol address.
    constructor(address _asset, address _protocol) ERC20("Vault Shares", "vSHARE") {
        asset = IERC20(_asset);
        lendingProtocol = MockLendingProtocol(_protocol);
    }

    /// @notice Returns the total assets held by the vault in the lending protocol.
    function totalAssets() public view returns (uint256) {
        return lendingProtocol.getBalance(address(this));
    }

    /// @notice Deposits assets and mints shares to the receiver.
    /// @dev Calculates shares based on the current exchange rate to prevent dilution.
    /// @param assets The amount of underlying assets to deposit.
    function deposit(uint256 assets) external {
        if (assets == 0) revert ZeroAssets();

        uint256 shares;
        if (totalSupply() == 0) {
            shares = assets;
        } else {
            // Formula: (assets * totalSupply) / totalAssets
            shares = (assets * totalSupply()) / totalAssets();
        }

        if (shares == 0) revert ZeroShares();

        // 1. Pull assets from user
        asset.transferFrom(msg.sender, address(this), assets);

        // 2. Deposit into external protocol
        asset.approve(address(lendingProtocol), assets);
        lendingProtocol.deposit(assets);

        // 3. Mint representative shares
        _mint(msg.sender, shares);
    }

    /// @notice Burns shares and withdraws the underlying assets + yield.
    /// @param shares The amount of shares to burn.
    function withdraw(uint256 shares) external {
        if (shares == 0) revert ZeroShares();

        // Formula: (shares * totalAssets) / totalSupply
        uint256 assets = (shares * totalAssets()) / totalSupply();

        if (assets == 0) revert ZeroAssets();

        _burn(msg.sender, shares);
        lendingProtocol.withdraw(assets);
        asset.transfer(msg.sender, assets);
    }
}
