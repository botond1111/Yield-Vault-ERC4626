# Yield-Vault-ERC4626
Solidity implementation of an ERC-4626 compliant Tokenized Vault with share calculation and anti-dilution protection.

# 🏦 Smart Yield Vault (ERC-4626 Style)

## 💡 Overview
This project implements a **Yield Generating Vault** inspired by the ERC-4626 standard. It allows users to deposit funds (USDC) into a pooled strategy, which interacts with external lending protocols to generate interest.

The system features an automated **share calculation mechanism** that protects existing liquidity providers from dilution when new capital enters the pool.

## 🛠 Architecture & Files

* **`contracts/YieldVault.sol`**: The core logic.
    * Manages deposits and withdrawals.
    * Calculates exchange rates between Assets (USDC) and Shares (vSHARE).
    * Directs funds to external protocols.
* **`contracts/Mocks.sol`**: Testing infrastructure.
    * Simulates an ERC20 Token (MockUSDC).
    * Simulates a Lending Protocol (like Aave) to test yield generation mechanics without mainnet forking.

## 🔑 Key Features

* **Anti-Dilution Math:** Implementation of the standard formula `shares = (assets * totalSupply) / totalAssets` to ensure fair value distribution.
* **Gas Optimization:** Uses custom errors (`error ZeroShares()`) instead of string require messages to save gas.
* **Separation of Concerns:** Modular design separating the vault logic from the underlying asset and the strategy.
* **Yield Simulation:** Includes helper functions to simulate interest accrual for testing purposes.

## 🚀 How to Run (Remix)

1.  Deploy `MockUSDC` from `Mocks.sol`.
2.  Deploy `MockLendingProtocol` using the USDC address.
3.  Deploy `YieldVault` using the USDC and Protocol addresses.
4.  **Test Cycle:**
    * Approve USDC for the Vault.
    * Call `deposit()` to receive vSHARE tokens.
    * Simulate interest in the Protocol.
    * Call `withdraw()` to redeem principal + profit.

## ⚙️ Tech Stack
* **Language:** Solidity ^0.8.20
* **Standard:** ERC-20, Ownable
* **Tooling:** Remix IDE / Hardhat ready
