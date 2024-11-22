// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IStorage {
    function getNum() external view returns  (uint);
    function add() external;
}

contract Contract2 {
    constructor() {

    }
    function proxyAdd() public {
        IStorage(0xfB72aAdB17a855D27A68B565ee0a84CB30A387e4).add();
    }

    function proxyGet() public view returns (uint) {
        return IStorage(0xfB72aAdB17a855D27A68B565ee0a84CB30A387e4).getNum();
    }
}