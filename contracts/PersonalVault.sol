// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PersonalVault {
    // State variables
    address public owner;
    uint256 public unlockTime;

    // Events
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(uint256 amount, uint256 timestamp);
    event LockExtended(uint256 newUnlockTime);

    // Custom errors
    error FundsLocked();
    error NotOwner();
    error InvalidUnlockTime();
    error NoFunds();
    error TransferFailed();

    // Only owner modifier
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // Constructor
    constructor(uint256 _unlockTime) payable {
        if (_unlockTime <= block.timestamp) {
            revert InvalidUnlockTime();
        }

        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    // Deposit ETH
    function deposit() external payable onlyOwner {
        if (msg.value == 0) {
            revert NoFunds();
        }

        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw all ETH after unlock time
    function withdraw() external onlyOwner {
        if (block.timestamp < unlockTime) {
            revert FundsLocked();
        }

        uint256 amount = address(this).balance;

        if (amount == 0) {
            revert NoFunds();
        }

        // Checks-Effects-Interactions
        (bool success, ) = payable(owner).call{value: amount}("");

        if (!success) {
            revert TransferFailed();
        }

        emit Withdrawal(amount, block.timestamp);
    }

    // Extend lock time
    function extendLock(uint256 newTime) external onlyOwner {
        if (newTime <= unlockTime) {
            revert InvalidUnlockTime();
        }

        unlockTime = newTime;

        emit LockExtended(newTime);
    }

    // View current vault balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}