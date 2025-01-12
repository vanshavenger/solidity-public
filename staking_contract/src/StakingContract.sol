// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract {
    uint256 public totalStaked;
    mapping(address => uint256) public staked;
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function stake(uint256 amount) public payable {
        (bool success, ) = implementation.delegatecall(abi.encodeWithSignature("stake(uint256)", amount));

        if (!success) {
            revert("Delegatecall failed");
        }

        require(success, "Delegatecall failed");
    }

    function unstake(uint256 amount) public payable {
        (bool success, ) = implementation.delegatecall(abi.encodeWithSignature("unstake(uint256)", amount));

        if (!success) {
            revert("Delegatecall failed");
        }

        require(success, "Delegatecall failed");
    }

    fallback() external payable {
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    receive() external payable {
        require(msg.value > 0, "Incorrect amount");
    }
}
