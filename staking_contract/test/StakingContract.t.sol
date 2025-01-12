// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StakingContract.sol";
import "src/ImplementationV1.sol";

contract TestContract is Test {
    StakingContract c;
    ImplementationV1 impv1;
    address owner;
    address user;

    receive() external payable {}

    function setUp() public {
        owner = address(this);
        user = address(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f);
        impv1 = new ImplementationV1();
        c = new StakingContract(address(impv1));
    }

    function testStake() public {
        uint256 value = 10 ether;
        (bool success,) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        assert(c.totalStaked() == value);
    }

    function testFailStake() public {
        uint256 value = 10 ether;
        (bool success,) = address(c).call(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake should fail but didn't");
    }

    function testUnStake() public {
        uint256 value = 10 ether;
        (bool success,) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        (success,) = address(c).call(abi.encodeWithSignature("unstake(uint256)", value));
        require(success, "Unstake failed");
        assert(c.totalStaked() == 0);
    }

    function testStakeOnAnotherUser() public {
        uint256 value = 10 ether;
        vm.deal(user, value);
        vm.startPrank(user);
        (bool success,) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");
        assert(c.staked(user) == value);
    }

    function testUnStakeOnAnotherUser() public {
        uint256 value = 10 ether;
        vm.deal(user, value);
        vm.startPrank(user);
        (bool success,) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");

        (success,) = address(c).call(abi.encodeWithSignature("unstake(uint256)", value / 2));
        require(success, "Unstake failed");
        assert(c.staked(user) == value / 2);
    }

    function testPause() public {
        (bool success,) = address(c).call(abi.encodeWithSignature("pause()"));
        require(success, "Pause failed");
        (bool paused, bytes memory returnedData) = address(c).call(abi.encodeWithSignature("paused()"));
        require(paused, "Paused check failed");
        assert(abi.decode(returnedData, (bool)));
    }

    function testUnpause() public {
        (bool success,) = address(c).call(abi.encodeWithSignature("pause()"));
        require(success, "Pause failed");
        (success,) = address(c).call(abi.encodeWithSignature("unpause()"));
        require(success, "Unpause failed");
        (bool paused, bytes memory returnedData) = address(c).call(abi.encodeWithSignature("paused()"));
        require(paused, "Paused check failed");
        assert(!abi.decode(returnedData, (bool)));
    }

    function testFailStakeWhenPaused() public {
        (bool success,) = address(c).call(abi.encodeWithSignature("pause()"));
        require(success, "Pause failed");

        uint256 value = 10 ether;
        (success,) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake should fail when paused but didn't");
    }

    function testFailUnstakeWhenPaused() public {
        uint256 value = 10 ether;
        (bool success,) = address(c).call{value: value}(abi.encodeWithSignature("stake(uint256)", value));
        require(success, "Stake failed");

        (success,) = address(c).call(abi.encodeWithSignature("pause()"));
        require(success, "Pause failed");

        (success,) = address(c).call(abi.encodeWithSignature("unstake(uint256)", value));
        require(success, "Unstake should fail when paused but didn't");
    }

    function testFailPauseByNonOwner() public {
        vm.prank(user);
        (bool success,) = address(c).call(abi.encodeWithSignature("pause()"));
        require(success, "Pause should fail for non-owner but didn't");
    }

    function testFailUnpauseByNonOwner() public {
        (bool success,) = address(c).call(abi.encodeWithSignature("pause()"));
        require(success, "Pause failed");

        vm.prank(user);
        (success,) = address(c).call(abi.encodeWithSignature("unpause()"));
        require(success, "Unpause should fail for non-owner but didn't");
    }
}
