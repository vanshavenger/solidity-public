// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VGToken {
    address public owner;
    mapping(address => uint) private holdings;
    uint supply;
    mapping (address => mapping (address => uint)) public allowances;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    uint decimals = 3;
    string public name = "VGToken";
    string public symbol = "VGT";


    modifier onlyOwner {
        require(msg.sender == owner, "Only Owner is authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mint(uint amount) onlyOwner public {
        holdings[msg.sender] += amount;
        supply += amount;
    }

    function mintTo(address destination,uint amount) onlyOwner public {
        holdings[destination] += amount;
        supply += amount;
    }

    function transfer(address destination, uint amount) public {
        require(holdings[msg.sender] >= amount, "Don't have required money!");
        holdings[msg.sender] -= amount;
        holdings[destination] += amount;

    }

    function balanceOf(address user) onlyOwner view public returns (uint)  {
        return holdings[user];
    } 

    function totalSupply() onlyOwner view public returns (uint)  {
        return supply;
    } 

    function getOwner() view public returns (address)  {
        return owner;
    } 

    function burn(uint amount) public {
         require(holdings[msg.sender] >= amount, "Don't have required money!");
         holdings[msg.sender] -= amount;
         supply -= amount;
    }

    function approve(address spender, uint amount) public {
        allowances[msg.sender][spender] = amount;
    }

    function transferFrom(address sender, address recipient, uint amount) public {
        require(holdings[sender] >= amount, "Don't have required money!");
        require(allowances[sender][msg.sender] >= amount, "Not allowed to transfer this amount!");
        holdings[sender] -= amount;
        holdings[recipient] += amount;
        allowances[sender][msg.sender] -= amount;
    }

    function allowance(address sender, address spender) public view returns (uint) {
        return allowances[sender][spender];
    }
}