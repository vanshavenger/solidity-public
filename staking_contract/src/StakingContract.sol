// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingContract is Pausable, Ownable, ERC20 {
    uint256 public totalStaked;
    mapping(address => uint256) public staked;
    mapping(address => uint256) public stakingTime;
    address public implementation;

    constructor(address _implementation) Ownable(msg.sender) ERC20("Staking Reward", "STR") {
        implementation = _implementation;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function upgradeImplementation(address newImplementation) public onlyOwner {
        implementation = newImplementation;
    }

    fallback() external payable whenNotPaused {
        (bool success,) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    receive() external payable whenNotPaused {
        require(msg.value > 0, "Incorrect amount");
    }
}
