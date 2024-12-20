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

    event Burn (address indexed sender, uint256 _tokenValue);

    constructor(address _tokenAddress) Ownable(_msgSender()) {
        tokenAddress = _tokenAddress;
    }

    function burn(address _tokenAddress, uint256 _amount) public {
        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        IBBase(_tokenAddress).burn(msg.sender, _amount);

        balanceOfTokens[msg.sender] -= _amount;

        emit Burn(msg.sender, _amount);
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {

        require(_tokenAddress == tokenAddress, "Invalid token address");
        require(_amount > 0, "Invalid amount");
        require(balanceOfTokens[msg.sender] >= _amount, "Insufficient balance");

        balanceOfTokens[msg.sender] -= _amount;

        IBBase(_tokenAddress).mint(msg.sender, _amount);

    }

    function depositOnOtherSide(address userAccount, uint256 _amount) public onlyOwner {
        require(balanceOfTokens[userAccount] > 0, "Insufficient balance");

        balanceOfTokens[userAccount] += _amount;
    }
}
