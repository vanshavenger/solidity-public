// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Counter.sol";

contract TestCounter is Test {
    Counter c;

    function setUp() public {
        c = new Counter(100);
    }

    function testIncrement() public {
        c.increment();
        assertEq(c.num(), 101);
    }

    function testDecrement() public {
        c.decrement();
        assertEq(c.num(), 99);
    }

    function testIncrementTwice() public {
        c.increment();
        c.increment();
        assertEq(c.num(), 102);
    }

    function testDecrementTwice() public {
        c.decrement();
        c.decrement();
        assertEq(c.num(), 98);
    }

    function testIncrementDecrement() public {
        c.increment();
        c.decrement();
        assertEq(c.num(), 100);
    }

    function testDecrementIncrement() public {
        c.decrement();
        c.increment();
        assertEq(c.num(), 100);
    }

}
