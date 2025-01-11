// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract {
    uint public num;
    address public delegate;

    receive() external payable {}

    constructor(address _delegate) {
        delegate = _delegate;
    }

    function setNumTo2() public {
        require(delegate != address(0), "Invalid delegate address");

        (bool success, ) = delegate.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", 2)
        );
        
        require(success, "Delegatecall failed");
    }

    function setDelegate(address _delegate) public  {
        require(_delegate != address(0), "Invalid delegate address");
        delegate = _delegate;
    }

    fallback(bytes calldata) external payable returns (bytes memory) {
        require(delegate != address(0), "Invalid delegate address");

        (bool success, bytes memory data) = delegate.delegatecall(msg.data);
        
        require(success, "Delegatecall failed");
        return data;
    }
}

contract Delegate {
    uint public num;

    constructor() {}

    function setNum(uint _num) public {
        num = _num;
    }
}