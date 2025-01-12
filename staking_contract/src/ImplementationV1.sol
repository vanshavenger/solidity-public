// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract ImplementationV1 {
    uint256 public totalStaked;
    mapping(address => uint256) public staked;

    function stake(uint256 amount) public payable {
        require(amount > 0, "Incorrect amount");
        require(msg.value == amount, "Incorrect amount");

        staked[msg.sender] += amount;
        totalStaked += amount;
    }

    function unstake(uint256 amount) public payable {
        require(amount > 0, "Incorrect amount");
        require(staked[msg.sender] >= amount, "Not enough staked");

        staked[msg.sender] -= amount;
        totalStaked -= amount;

        payable(msg.sender).transfer(amount);
    }

    receive() external payable {
        require(msg.value > 0, "Incorrect amount");
    }
}