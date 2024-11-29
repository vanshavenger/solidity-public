// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract User {
    address public owner;
    mapping(address => uint) private holdings;
    uint totalSupply;


    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner is authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mint(uint amount) onlyOwner public {
        holdings[msg.sender] += amount;
        totalSupply += amount;
    }

    function mintTo(address destination,uint amount) onlyOwner public {
        holdings[destination] += amount;
        totalSupply += amount;
    }

    function transfer(address destination, uint amount) public {
        require(holdings[msg.sender] >= amount, "Don't have required money!");
        holdings[msg.sender] -= amount;
        holdings[destination] += amount;

    }

    function balance(address user) onlyOwner view public returns (uint)  {
        return holdings[user];
    } 

    function getTotalSupply() onlyOwner view public returns (uint)  {
        return totalSupply;
    } 

    function getOwner() view public returns (address)  {
        return owner;
    } 
    
    function burn(uint amount) public {
         require(holdings[msg.sender] >= amount, "Don't have required money!");
         holdings[msg.sender] -= amount;
         totalSupply -= amount;
    }
}