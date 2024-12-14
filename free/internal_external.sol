// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

event VoteCast(string message);

contract Visibilty {
    string private message;
    function InternalFunction () internal returns (string memory) {
        message = "This is an internal function";
        return message;
    }

    function ExternalFunction () external returns (string memory) {
        
        emit VoteCast("This is an external function");
        message =  InternalFunction();
        message = string(abi.encodePacked(message, " and this is an external function"));
        return message ;
    }

    function PublicFunction () public returns (string memory) {
        return InternalFunction();
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }
}