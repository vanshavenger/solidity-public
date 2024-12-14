// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet {
    address payable public owner;
    modifier onlyOwner {
        require(msg.sender == owner, "Not owner");
        _;
    }
    constructor() {
        owner = payable(msg.sender);
    }
    event Deposited(address indexed sender, uint256 amount);
    function deposit() public payable {
        emit Deposited(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint256) {

        return address(this).balance;
    }

    function withdraw(uint _amount) public onlyOwner() {
        require(_amount <= getBalance(), "Insufficient balance");
        owner.transfer(_amount);
    }

    function withdrawAll() public onlyOwner() {
        return withdraw(getBalance());
    }
} 