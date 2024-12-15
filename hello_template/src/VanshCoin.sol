// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {console} from "forge-std/console.sol";

contract VanshCoin is ERC20, Ownable, ERC20Pausable {
    constructor() ERC20("Vansh", "VC") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        console.log("Minting %s to %s", amount, to);
        _mint(to, amount);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function test() public payable {
        console.log("Test function called with %s", msg.value);
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, value);
    }
}
