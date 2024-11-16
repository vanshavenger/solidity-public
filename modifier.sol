// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OnlyOwner {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    function protectedFunction() onlyOwner() public view returns (string memory) {
        return "You are the owner";
    }

    modifier onlyOwner2() {
        _;
        require(msg.sender == owner, "Only owner can call this function");
        
    }

    function changeOwner(address _newOwner) onlyOwner() onlyOwner2() public {
        owner = _newOwner;
    }
}