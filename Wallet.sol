// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.7.0;

contract SharedWallet {
    address public owner;
    mapping(address => uint256) allowance;

    // Initalizes with owner being set to the caller who creates the wallet.
    constructor() {
        owner = msg.sender;
    }

    // Event to check on allowances\
    event AllowanceChanged(
        address who,
        address whoChanged,
        uint256 old,
        uint256 amount
    );

    // Falll back function to accept money from anyone
    receive() external payable {}

    // Function to assign allownace
    function allowAllowance(address who, uint256 amount) public onlyOwner {
        emit AllowanceChanged(who, msg.sender, allowance[who], amount);
        allowance[who] = amount;
    }

    // Only Owner modification
    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Cannot do this as you're not the Owner of the contract"
        );
        _;
    }

    modifier moneyLeft(uint256 amount) {
        require(
            amount <= address(this).balance,
            "Smart contract has not enough moeny left in it"
        );
        _;
    }

    // Withdraw function to Withdraw money
    function withdraw(address payable to, uint256 amount)
        public
        moneyLeft(amount)
    {
        // owner can remove all money in contract
        // Check allownace of withdrawer.
        // FIX THIS.
        if (owner != msg.sender) {
            require(allowance[to] <= amount);
            allowance[to] = allowance[to] - amount;
        }
        emit AllowanceChanged(to, msg.sender, allowance[to], amount);
        to.transfer(amount);
    }
}
