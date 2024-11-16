// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Parent {
    string private message;

    constructor(string memory _message) {
        message = _message;
    }

    function greet() public virtual view returns (string memory) {
        return message;
    }
}