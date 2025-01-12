// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Pausable, Ownable {
    uint256 public totalStaked;
    mapping(address => uint256) public staked;
    address public implementation;

    constructor(address _implementation) Ownable(msg.sender) {
        implementation = _implementation;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    fallback() external payable whenNotPaused {
        (bool success,) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    receive() external payable whenNotPaused {
        require(msg.value > 0, "Incorrect amount");
    }
}
