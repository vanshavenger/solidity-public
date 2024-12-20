// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeETH is Ownable {
    address public tokenAddress;

    mapping(address => uint256) public balanceOfTokens;

    event LockEvent(address indexed sender, uint256 _tokenValue);
    event WithDrawEvent(address indexed sender, uint256 _tokenValue);

    event TokenUnlock(address indexed _to, uint256 _amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function deposit(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");

        require(
            IERC20(_tokenAddress).allowance(msg.sender, address(this)) >= _amount,
            "Check the token allowance, it should be greater than the amount"
        );

        bool sent = IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _amount);

        require(sent, "Token transfer failed");

        balanceOfTokens[msg.sender] += _amount;

        emit LockEvent(msg.sender, _amount);
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        balanceOfTokens[msg.sender] -= _amount;

        bool sent = IERC20(_tokenAddress).transfer(msg.sender, _amount);

        require(sent, "Token transfer failed");

        emit WithDrawEvent(msg.sender, _amount);
    }

    function burnOnOtherSide(address userAccount, uint256 _amount) public onlyOwner {
        require(balanceOfTokens[userAccount] > 0, "Insufficient balance");

        balanceOfTokens[userAccount] += _amount;

        emit TokenUnlock(userAccount, _amount);
    }
}
