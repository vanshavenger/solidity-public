// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "../lib/openzeppelin-contracts/lib/forge-std/src/Script.sol";
import {BVCoin} from "../src/BVCoin.sol";
import {VCoin} from "../src/VCoin.sol";
import {BridgeETH} from "../src/BridgeETH.sol";
import {BridgeBase} from "../src/BridgeBase.sol";
import {console} from "../lib/openzeppelin-contracts/lib/forge-std/src/console.sol";

contract DeployBridge is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        BVCoin bvCoin = new BVCoin();
        VCoin vCoin = new VCoin();
        BridgeETH bridgeETH = new BridgeETH(address(vCoin));
        BridgeBase bridgeBase = new BridgeBase(address(bvCoin));

        // Transfer ownership of BVCoin to BridgeBase
        bvCoin.transferOwnership(address(bridgeBase));

        vm.stopBroadcast();

        console.log("BVCoin deployed to:", address(bvCoin));
        console.log("VCoin deployed to:", address(vCoin));
        console.log("BridgeETH deployed to:", address(bridgeETH));
        console.log("BridgeBase deployed to:", address(bridgeBase));
    }
}

