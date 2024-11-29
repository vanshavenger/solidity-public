// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Will {
    address private owner;  
    address private recipient;
    uint256 private lastPingTimestamp;

    constructor(address _receipt) {
        owner = msg.sender;
        recipient = _receipt;
        lastPingTimestamp = block.timestamp;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyRecipient {
        require(msg.sender == recipient, "Not recipient");
        _;
    }

    function changeRecipient(address _newRecipient) public onlyOwner {
        recipient = _newRecipient;
    }

    function ping() public onlyOwner() returns (address, address) {
        lastPingTimestamp = block.timestamp;
        return (owner, recipient);
    }

    function drain() view public onlyRecipient {
        require(block.timestamp > lastPingTimestamp + 365 days, "Owner has pinged recently");
    }
}