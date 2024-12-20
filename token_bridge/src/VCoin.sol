// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract VCoin is ERC20, Ownable {
    constructor() ERC20("VCoin", "VC") Ownable(_msgSender()) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
