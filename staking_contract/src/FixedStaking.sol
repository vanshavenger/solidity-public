// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract FixedStaking is ERC20 {
    mapping(address => uint256) public staked;
    mapping(address => uint256) public stakingFromTs;

    constructor() ERC20("FixedStaking", "FIXED") {
        _mint(msg.sender, 1000000 * 1e18);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Incorrect amount");
        require(balanceOf(msg.sender) >= amount, "Not enough balance");

        _transfer(msg.sender, address(this), amount);

        if (staked[msg.sender] > 0) {
            claim();
        }

        staked[msg.sender] += amount;
        stakingFromTs[msg.sender] = block.timestamp;
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Incorrect amount");
        require(staked[msg.sender] >= amount, "Not enough staked");

        claim();

        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    function claim() public {
        require(staked[msg.sender] > 0, "No stake found");

        uint256 stakedTime = block.timestamp - stakingFromTs[msg.sender];
        uint256 rewardTokens = staked[msg.sender] * stakedTime / 3.154e7;

        _mint(msg.sender, rewardTokens);

        stakingFromTs[msg.sender] = block.timestamp;
    }
}