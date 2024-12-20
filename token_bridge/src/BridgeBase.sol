// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IBBase is IERC20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract BridgeBase is Ownable {
    address public tokenAddress;
    mapping(address => uint256) public balanceOfTokens;

    event Burn(address indexed sender, uint256 _tokenValue);
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    constructor(address _tokenAddress) Ownable(_msgSender()) {
        require(_tokenAddress != address(0), "Zero address not allowed");
        tokenAddress = _tokenAddress;
    }

    function burn(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        balanceOfTokens[msg.sender] -= _amount;

        IBBase(_tokenAddress).burn(msg.sender, _amount);

        emit Burn(msg.sender, _amount);
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        balanceOfTokens[msg.sender] -= _amount;
        
        IBBase(_tokenAddress).mint(msg.sender, _amount);

        emit Withdrawal(msg.sender, _amount);
    }

    function depositOnOtherSide(address userAccount, uint256 _amount) public onlyOwner {
        require(userAccount != address(0), "Invalid user address");
        require(_amount > 0, "Invalid amount");

        balanceOfTokens[userAccount] += _amount;

        emit Deposit(userAccount, _amount);
    }
}