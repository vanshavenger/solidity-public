// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/VanshCoin.sol";

contract TestVanshCoin is Test {
    VanshCoin c;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        c = new VanshCoin();
    }

    function test_ExpectEmit() public {
        c.mint(address(this), 100);

        vm.expectEmit(true, true, false, true);

        emit Transfer(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);

        c.transfer(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);
    }

    function test_ExpectApprovalEmit() public {
        c.mint(address(this), 100);

        vm.expectEmit(true, true, false, true);
        emit Approval(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        c.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);

        vm.prank(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        c.transferFrom(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
    }

    function test_DealExample() public {
        address a = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        uint256 amount = 10 ether;

        vm.deal(a, amount);

        assertEq(address(a).balance, amount, "Balance should be 10 ether");
    }

    function test_HoaxExample() public {
        address a = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        uint256 amount = 10 ether;

        hoax(a, amount)();

        c.test{value: amount};

        assertEq(address(a).balance, amount, "Balance should be 10 ether");
    }

    function testName() public {
        assertEq(c.name(), "Vansh", "Name should be Vansh");
    }

    function testSymbol() public {
        assertEq(c.symbol(), "VC", "Symbol should be VC");
    }

    function testMint() public {
        c.mint(address(this), 100);
        assertEq(c.balanceOf(address(this)), 100, "Balance should be 100");
        assertEq(c.balanceOf(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 0, "Balance should be 0");

        c.mint(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);
        assertEq(c.balanceOf(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 100, "Balance should be 100");
    }

    function testTransfer() public {
        c.mint(address(this), 100);
        c.transfer(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        assertEq(c.balanceOf(address(this)), 50, "Balance should be 50");
        assertEq(c.balanceOf(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 50, "Balance should be 50");

        vm.prank(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        c.transfer(address(this), 25);

        assertEq(c.balanceOf(address(this)), 75, "Balance should be 75");
        assertEq(c.balanceOf(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 25, "Balance should be 25");
    }

    function testApproval() public {
        c.mint(address(this), 100);
        c.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        assertEq(c.allowance(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 50, "Allowance should be 50");

        vm.prank(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        c.transferFrom(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);

        assertEq(c.balanceOf(address(this)), 50, "Balance should be 50");
        assertEq(c.balanceOf(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 50, "Balance should be 50");
        assertEq(c.allowance(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 0, "Allowance should be 50");

        // c.transferFrom(address(this),  0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 1);
        // assertEq(c.balanceOf(address(this)), 50, "Balance should be 50");
        // assertEq(c.balanceOf(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 50, "Balance should be 50");
        // assertEq(c.allowance(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 0, "Allowance should be 0");
    }

    function testFailApprovals() public {
        c.mint(address(this), 100);
        c.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        assertEq(c.allowance(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), 50, "Allowance should be 50");

        vm.prank(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        c.transferFrom(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 51);
    }

    function testPause() public {
        c.pause();
        assertTrue(c.paused(), "Contract should be paused");
    }

    function testFailTransfer() public {
        c.mint(address(this), 100);
        c.transfer(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 101);
    }

    function testFailTransferFrom() public {
        c.mint(address(this), 100);
        c.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        c.transferFrom(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 51);
    }

    function testFailTransferFrom2() public {
        c.mint(address(this), 100);
        c.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        c.transferFrom(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 50);
        c.transferFrom(address(this), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 1);
    }

    // function testInitialBalance() public {
    //     assertEq(c.balanceOf(address(this)), 100, "Initial balance should be 100");
    // }

    // function testMint() public {
    //     c.mint(address(this), 100);
    //     assertEq(c.balanceOf(address(this)), 200, "Balance should increase by 100");
    // }

    // function testPause() public {
    //     c.pause();
    //     assertTrue(c.paused(), "Contract should be paused");
    // }

    // function testTransfer() public {
    //     c.transfer(address(this), 10);
    //     assertEq(c.balanceOf(address(this)), 100, "Balance should not increase");
    // }

    // function testApprove() public {
    //     c.approve(address(this), 10);
    //     assertEq(c.allowance(address(this), address(this)), 10, "Allowance should be 10");
    // }

    // function testNum() public {
    //     assertEq(c.num(), 1, "Counter should start at 1");
    // }

    // function testIncrement() public {
    //     c.increment();
    //     assertEq(c.num(), 2, "Counter should increment by 1");
    // }

    // function testDecrement() public {
    //     c.decrement();
    //     assertEq(c.num(), 0);
    // }

    // function testIncrementTwice() public {
    //     c.increment();
    //     c.increment();
    //     assertEq(c.num(), 3);
    // }

    // function testFailDecrementTwice() public {
    //     c.decrement();

    //     c.decrement();c.decrement();c.decrement();c.decrement();c.decrement();
    // }

    // function testIncrement() public {
    //     c.increment();
    //     assertEq(c.num(), 101, "Counter should increment by 1");
    // }

    // function testDecrement() public {
    //     c.decrement();
    //     assertEq(c.num(), 99);
    // }

    // function testIncrementTwice() public {
    //     c.increment();
    //     c.increment();
    //     assertEq(c.num(), 102);
    // }

    // function testDecrementTwice() public {
    //     c.decrement();
    //     c.decrement();
    //     assertEq(c.num(), 98);
    // }

    // function testIncrementDecrement() public {
    //     c.increment();
    //     c.decrement();
    //     assertEq(c.num(), 100);
    // }

    // function testDecrementIncrement() public {
    //     c.decrement();
    //     c.increment();
    //     assertEq(c.num(), 100);
    // }
}
