// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Mock USDC Token
/// @notice ERC20 token for testing purposes with initial minting.
contract MockUSDC is ERC20 {
    constructor() ERC20("Mock USDC", "mUSDC") {
        _mint(msg.sender, 1_000_000 * 10**18);
    }
}

/// @title Mock Lending Protocol
/// @notice Simulates an external DeFi protocol (like Aave) for yield generation tests.
contract MockLendingProtocol {
    IERC20 public immutable usdc;
    mapping(address => uint256) private balances;

    error InsufficientBalance();

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    /// @notice Deposits assets into the protocol.
    /// @param amount The amount of tokens to deposit.
    function deposit(uint256 amount) external {
        usdc.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    /// @notice Withdraws assets from the protocol.
    /// @param amount The amount of tokens to withdraw.
    function withdraw(uint256 amount) external {
        if (balances[msg.sender] < amount) revert InsufficientBalance();
        balances[msg.sender] -= amount;
        usdc.transfer(msg.sender, amount);
    }

    /// @notice Simulates yield generation by artificially increasing a user's balance.
    /// @dev Only for testing. In production, yield comes from borrowers.
    function simulateInterest(address account, uint256 interestAmount) external {
        balances[account] += interestAmount;
    }

    /// @notice Returns the total balance (principal + interest) of an account.
    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }
}
