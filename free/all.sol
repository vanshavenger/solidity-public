// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StatusContract {
    enum Status {
        PENDING,
        ACTIVE,
        COMPLETED
    }

    Status public currentStatus;

    address payable public owner;

    uint256 public currentBalance; 



    constructor() payable {
        currentStatus = Status.PENDING;
        owner = payable(msg.sender);
        currentBalance = msg.value;
    }

    event StatusChanged(Status newStatus);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function Activate() external onlyOwner() {
        currentStatus = Status.ACTIVE;
        emit StatusChanged(Status.ACTIVE);
    }

    function Complete() external onlyOwner() {
        require(currentStatus == Status.ACTIVE, "Cannot complete a non-active contract");
        currentStatus = Status.COMPLETED;
        emit StatusChanged(Status.COMPLETED);
    }

    function FundContract() external payable {
        require(msg.value > 0, "Must send some ether");
        currentBalance += msg.value;
    }

    function IsComplete() external view returns (bool) {
        return currentStatus == Status.COMPLETED;
    }

    function _GetStatus() internal view returns (Status) {
        return currentStatus;
    }
}