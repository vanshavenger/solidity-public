// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string private message;

    constructor() {
        message = "Hello, Workd!";
    }

    function someFunction() public view returns (string memory) {
        return message;
    }
}