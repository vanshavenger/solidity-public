// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Calculator {
    uint256 private result;

    function add(uint256 a, uint256 b) public returns (uint256) {
        result = a + b;
        return result;
    }

    function subtract(uint256 a, uint256 b) public returns (uint256) {
        result = a - b;
        return result;
    }

    function multiply(uint256 a, uint256 b) public returns (uint256) {
        require(a != 0 && b != 0, "Cannot multiply by zero");
        result = a * b;
        return result;
    }

    function divide(uint256 a, uint256 b) public returns (uint256) {
        require(b != 0, "Cannot divide by zero");
        result = a / b;
        return result;
    }

    function getResult() public view returns (uint256) {
        return result;
    }
}