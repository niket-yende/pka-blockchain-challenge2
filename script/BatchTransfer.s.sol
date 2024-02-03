// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {BatchTransfer} from "../src/BatchTransfer.sol";
import {MyToken} from "../src/MyToken.sol";

contract BatchTransferScript is Script {
    
    function run() public {
        vm.broadcast();
        // Deploy the dummy ERC20 token
        MyToken myToken = new MyToken();
        BatchTransfer batchTransfer = new BatchTransfer(address(myToken));
        // mint the tokens for BatchTransfer contract
        // myToken.mint(address(batchTransfer), 10000);
    }
}
