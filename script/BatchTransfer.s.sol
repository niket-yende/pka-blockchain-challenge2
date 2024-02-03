// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {BatchTransfer} from "../src/BatchTransfer.sol";
import {MyToken} from "../src/MyToken.sol";
import "forge-std/console.sol";

contract BatchTransferScript is Script {
    uint64 public constant batchLimit = 10;
    
    function run() public {
        vm.broadcast();
        // Deploy the dummy ERC20 token
        MyToken myToken = new MyToken();
        BatchTransfer batchTransfer = new BatchTransfer(address(myToken), batchLimit);
        console.log('Deployed BatchTransfer address: ', address(batchTransfer));
        // mint the tokens for BatchTransfer contract
        // myToken.mint(address(batchTransfer), 10);
    }
}
