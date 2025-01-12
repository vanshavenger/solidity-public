// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ImplementationV1 is Pausable, Ownable, ERC20 {
    uint256 public totalStaked;
    mapping(address => uint256) public staked;
    mapping(address => uint256) public stakingTime;

    uint256 public constant REWARD_PERIOD = 10 days;
    uint256 public constant REWARD_AMOUNT = 100 * 1e18;

    constructor() Ownable(msg.sender) ERC20("Staking Reward", "STR") {}

    function stake(uint256 amount) public payable whenNotPaused {
        require(amount > 0, "Incorrect amount");
        require(msg.value == amount, "Incorrect amount");

        if (staked[msg.sender] == 0) {
            stakingTime[msg.sender] = block.timestamp;
        }

        staked[msg.sender] += amount;
        totalStaked += amount;
    }

    function unstake(uint256 amount) public whenNotPaused {
        require(amount > 0, "Incorrect amount");
        require(staked[msg.sender] >= amount, "Not enough staked");

        uint256 stakedTime = block.timestamp - stakingTime[msg.sender];
        if (stakedTime >= REWARD_PERIOD) {
            uint256 rewardTokens = (stakedTime / REWARD_PERIOD) * REWARD_AMOUNT;
            _mint(msg.sender, rewardTokens);
        }

        staked[msg.sender] -= amount;
        totalStaked -= amount;

        if (staked[msg.sender] == 0) {
            stakingTime[msg.sender] = 0;
        } else {
            stakingTime[msg.sender] = block.timestamp;
        }

        payable(msg.sender).transfer(amount);
    }

    function claimReward() public whenNotPaused {
        require(staked[msg.sender] > 0, "No stake found");
        uint256 stakedTime = block.timestamp - stakingTime[msg.sender];
        require(stakedTime >= REWARD_PERIOD, "Staking period not met");

        uint256 rewardTokens = (stakedTime / REWARD_PERIOD) * REWARD_AMOUNT;
        _mint(msg.sender, rewardTokens);

        stakingTime[msg.sender] = block.timestamp;
    }

    receive() external payable {
        require(msg.value > 0, "Incorrect amount");
    }
}
