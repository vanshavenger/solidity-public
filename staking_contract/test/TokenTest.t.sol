// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Token.sol";

contract TestContract is Test {
    Token c;

    function setUp() public {
        c = new Token(address(this));
    }

    function testMint() public {
        c.mint(address(this), 100);
        assert(c.balanceOf(address(this)) == 100);
    }

    function testFailMint() public {
        c.mint(address(this), 100);
        c.mint(address(this), 100);
        assert(c.balanceOf(address(this)) == 100);
    }

    function testSetStakingContract() public {
        c.setStakingContract(address(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f));
        assert(c.stakingContract() == address(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f));
    }


    
}
