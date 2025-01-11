// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract {
    uint public num;

    constructor() {}

    function setNumTo2(address sc) public {
        require(sc != address(0), "Invalid delegate address");

        (bool success, ) = sc.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", 2)
        );
        
        require(success, "Delegatecall failed");
    }
}

contract Delegate {
    uint public num;

    constructor() {}

    function setNum(uint _num) public {
        num = _num;
    }
}