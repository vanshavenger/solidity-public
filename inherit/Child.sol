// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Parent.sol";

contract Child is Parent {
    constructor(string memory _message) Parent(_message) {

    }
    
    function greet() public pure override returns (string memory) {
        return "Baap baap hota hai, beta beta hota hai";
    }
}