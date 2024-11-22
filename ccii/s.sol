// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage {
    uint public num;
    constructor(uint _num) {
        num = _num;
    }

    function add() public  {
        num += 1;
    }

    function getNum() public view returns (uint) {
        return num;
    }
}