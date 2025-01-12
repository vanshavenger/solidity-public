// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StakingContract.sol";

contract TestContract is Test {
    StakingContract c;

    receive() external payable {}

    function setUp() public {
        c = new StakingContract();
    }

    function testStake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStaked() == value);
    }

    function testFailStake() public {
        uint value = 10 ether;
        c.stake(value);
    }

    function testFailUnStake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        c.unstake(value + 1);
    }

    function testUnStake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        c.unstake(value);
        assert(c.totalStaked() == 0);
    }

}