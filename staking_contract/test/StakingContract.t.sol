// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StakingContract.sol";
import "src/ImplementationV1.sol";

contract TestContract is Test {
    StakingContract c;
    ImplementationV1 impv1;

    receive() external payable {}

    function setUp() public {
        impv1 = new ImplementationV1();
        c = new StakingContract(address(impv1));
    }

    function testStake() public {
        uint256 value = 10 ether;
        (bool success, ) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        assert(c.totalStaked() == value);
    }

    function testFailStake() public {
        uint256 value = 10 ether;
        (bool success, ) = address(c).call(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake should fail but didn't");
    }

    function testFailUnStake() public {
        uint256 value = 10 ether;
        (bool success, ) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        (success, ) = address(c).call(abi.encodeWithSignature("unstake(uint256)", value + 1));
        require(success, "Unstake should fail but didn't");
    }

    function testUnStake() public {
        uint256 value = 10 ether;
        (bool success, ) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        (success, ) = address(c).call(abi.encodeWithSignature("unstake(uint256)", value));
        require(success, "Unstake failed");
        assert(c.totalStaked() == 0);
    }

    function testStakeForAnotherAddress() public {
        uint256 value = 10 ether;
        address user = address(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f);
        vm.deal(user, value);
        vm.prank(user);
        (bool success, ) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        assert(c.totalStaked() == value);
    }

    function testUnStakeForAnotherAddress() public {
        uint256 value = 11 ether;
        address user = address(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f);
        vm.deal(user, value);
        vm.startPrank(user);
        assert(user.balance == value);
        (bool success, ) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        (success, ) = address(c).call(abi.encodeWithSignature("unstake(uint256)", value / 2));
        require(success, "Unstake failed");
        assert(user.balance == value / 2);
        assert(c.totalStaked() == value / 2);
        vm.stopPrank();
    }
}

