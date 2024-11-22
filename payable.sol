// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Money {
    uint public total;
    function deposit() public payable {
        total += msg.value;
    }  

    function withdraw(address payable add) public {
        payable(add).transfer(total);
    } 
}