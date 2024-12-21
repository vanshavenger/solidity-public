// SPDX-License-Identifier: MIT
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
    mapping(address => uint256) public nonces;

    event Burn(address indexed sender, uint256 _tokenValue, uint256 nonce);
    event Deposit(address indexed user, uint256 amount, uint256 nonce);
    event Withdrawal(address indexed user, uint256 amount, uint256 nonce);

    constructor(address _tokenAddress) Ownable(_msgSender()) {
        require(_tokenAddress != address(0), "Zero address not allowed");
        tokenAddress = _tokenAddress;
    }

    function burn(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        balanceOfTokens[msg.sender] -= _amount;
        uint256 nonce = nonces[msg.sender]++;

        IBBase(_tokenAddress).burn(msg.sender, _amount);

        emit Burn(msg.sender, _amount, nonce);
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        balanceOfTokens[msg.sender] -= _amount;
        uint256 nonce = nonces[msg.sender]++;

        IBBase(_tokenAddress).mint(msg.sender, _amount);

        emit Withdrawal(msg.sender, _amount, nonce);
    }

    function depositOnOtherSide(address userAccount, uint256 _amount, uint256 _nonce) public onlyOwner {
        require(userAccount != address(0), "Invalid user address");
        require(_amount > 0, "Invalid amount");
        require(_nonce == nonces[userAccount], "Invalid nonce");

        balanceOfTokens[userAccount] += _amount;
        nonces[userAccount]++;

        emit Deposit(userAccount, _amount, _nonce);
    }
}
