// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {console2} from "../lib/openzeppelin-contracts/lib/forge-std/src/console2.sol";
import {Test} from "../lib/openzeppelin-contracts/lib/forge-std/src/Test.sol";
import {BVCoin} from "../src/BVCoin.sol";
import {VCoin} from "../src/VCoin.sol";
import {BridgeETH} from "../src/BridgeETH.sol";
import {BridgeBase} from "../src/BridgeBase.sol";

contract BridgeTest is Test {
    BVCoin public bvCoin;
    VCoin public vCoin;
    BridgeETH public bridgeETH;
    BridgeBase public bridgeBase;
    
    address public owner;
    address public user1;
    address public user2;
    
    uint256 public constant INITIAL_MINT = 1000000 * 10**18;
    uint256 public constant BRIDGE_AMOUNT = 1000 * 10**18;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        bvCoin = new BVCoin();
        vCoin = new VCoin();
        bridgeETH = new BridgeETH(address(vCoin));
        bridgeBase = new BridgeBase(address(bvCoin));
        bvCoin.mint(user1, INITIAL_MINT);
        vCoin.mint(user1, INITIAL_MINT);
        bvCoin.transferOwnership(address(bridgeBase));
    }

    function test_InitialSetup() public {
        assertEq(bvCoin.balanceOf(user1), INITIAL_MINT);
        assertEq(vCoin.balanceOf(user1), INITIAL_MINT);
        assertEq(bridgeETH.tokenAddress(), address(vCoin));
        assertEq(bridgeBase.tokenAddress(), address(bvCoin));
        assertEq(bvCoin.owner(), address(bridgeBase));
    }

    function test_BridgeETHDeposit() public {
        vm.startPrank(user1);
        vCoin.approve(address(bridgeETH), BRIDGE_AMOUNT);
        bridgeETH.deposit(address(vCoin), BRIDGE_AMOUNT);
        vm.stopPrank();

        assertEq(vCoin.balanceOf(address(bridgeETH)), BRIDGE_AMOUNT);
        assertEq(bridgeETH.balanceOfTokens(user1), BRIDGE_AMOUNT);
    }

    function test_BridgeETHWithdraw() public {
        vm.startPrank(user1);
        vCoin.approve(address(bridgeETH), BRIDGE_AMOUNT);
        bridgeETH.deposit(address(vCoin), BRIDGE_AMOUNT);

        uint256 initialBalance = vCoin.balanceOf(user1);
        bridgeETH.withdraw(address(vCoin), BRIDGE_AMOUNT);
        vm.stopPrank();

        assertEq(vCoin.balanceOf(user1), initialBalance + BRIDGE_AMOUNT);
        assertEq(bridgeETH.balanceOfTokens(user1), 0);
    }

    function test_BridgeBaseBurn() public {
        vm.prank(owner);
        bridgeBase.depositOnOtherSide(user1, BRIDGE_AMOUNT);
        
        assertEq(bridgeBase.balanceOfTokens(user1), BRIDGE_AMOUNT, "Bridge balance not set correctly");
        
        vm.startPrank(user1);
        uint256 initialBalance = bvCoin.balanceOf(user1);
        bridgeBase.burn(address(bvCoin), BRIDGE_AMOUNT);
        vm.stopPrank();

        assertEq(bridgeBase.balanceOfTokens(user1), 0, "Bridge balance not reduced");
        assertEq(bvCoin.balanceOf(user1), initialBalance - BRIDGE_AMOUNT, "Token balance not burned");
    }

    function test_BridgeBaseWithdraw() public {
        vm.prank(owner);
        bridgeBase.depositOnOtherSide(user1, BRIDGE_AMOUNT);
        
        assertEq(bridgeBase.balanceOfTokens(user1), BRIDGE_AMOUNT, "Bridge balance not set correctly");
        
        uint256 initialBalance = bvCoin.balanceOf(user1);
        
        vm.startPrank(user1);
        bridgeBase.withdraw(address(bvCoin), BRIDGE_AMOUNT);
        vm.stopPrank();

        assertEq(bvCoin.balanceOf(user1), initialBalance + BRIDGE_AMOUNT, "Token balance not increased");
        assertEq(bridgeBase.balanceOfTokens(user1), 0, "Bridge balance not reduced");
    }

    function testFail_UnauthorizedBurnOnOtherSide() public {
        vm.prank(user1);
        bridgeETH.burnOnOtherSide(user1, BRIDGE_AMOUNT);
    }

    function testFail_UnauthorizedDepositOnOtherSide() public {
        vm.prank(user1);
        bridgeBase.depositOnOtherSide(user1, BRIDGE_AMOUNT);
    }

    function testFail_InvalidTokenAddress() public {
        vm.prank(user1);
        bridgeBase.burn(address(0), BRIDGE_AMOUNT);
    }

    function testFail_BurnWithoutBalance() public {
        vm.prank(user1);
        bridgeBase.burn(address(bvCoin), BRIDGE_AMOUNT);
    }
}

