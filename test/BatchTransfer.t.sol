// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {BatchTransfer} from "../src/BatchTransfer.sol";
import {MyToken} from "../src/MyToken.sol";
import "forge-std/console.sol";

contract BatchTransferTest is Test {
    BatchTransfer public batchTransfer;
    MyToken public myToken;
    uint256 public constant totalSupply = 10000;
    
    function setUp() public {
        // Deploy the dummy ERC20 token
        myToken = new MyToken();
        batchTransfer = new BatchTransfer(address(myToken));
        // mint the tokens for BatchTransfer contract
        myToken.mint(address(batchTransfer), totalSupply);
    }

    function test_TransferBatch() public {
        uint contractBalanceBefore = myToken.balanceOf(address(batchTransfer));
        console.log('contractBalanceBefore: ', contractBalanceBefore);
        assertEq(contractBalanceBefore, totalSupply);

        uint totalAmountTransferred = 0;
        // amounts to be transferred
        uint256[] memory amounts = new uint256[](5);
        // Recepient addresses
        address[] memory toAddress = new address[](5);
        
        for (uint index = 0; index < amounts.length; index++) {
            toAddress[index] = address(uint160(uint(keccak256(abi.encodePacked(index))))); 
            amounts[index] = 200 * (2 ** index);   // Exponential increase in amount (200, 400, 800, 1600, 3200)
            totalAmountTransferred = totalAmountTransferred + amounts[index]; 
        }

        // Perform batch transfer
        batchTransfer.transferBatch(toAddress, amounts);    
        uint contractBalanceAfter = myToken.balanceOf(address(batchTransfer));
        console.log('contractBalanceAfter: ', contractBalanceAfter);
        assertEq(contractBalanceAfter, contractBalanceBefore - totalAmountTransferred);

        // Verify balance of each recepient address
        for (uint index = 0; index < toAddress.length; index++) {
            uint recepientBalance = myToken.balanceOf(address(toAddress[index]));
            console.log('address: %s, balance: %d', address(toAddress[index]), recepientBalance);
            assertEq(recepientBalance, amounts[index]);
        }
    }

    function test_DifferentArrayLength() public {
        uint contractBalanceBefore = myToken.balanceOf(address(batchTransfer));
        assertEq(contractBalanceBefore, totalSupply);

        // amounts to be transferred
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 200;
        amounts[1] = 400;
        amounts[2] = 800;
        // Recepient addresses
        address[] memory toAddress = new address[](2);
        toAddress[0] = address(1);
        toAddress[1] = address(2);

        vm.expectRevert("Arrays length mismatch");
        // Perform batch transfer
        batchTransfer.transferBatch(toAddress, amounts);    
        console.log('DifferentArrayLength test passed');
    }
   
    function test_ZeroAddress() public {
        uint contractBalanceBefore = myToken.balanceOf(address(batchTransfer));
        assertEq(contractBalanceBefore, totalSupply);

        // amounts to be transferred
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 200;
        amounts[1] = 400;
        
        // Recepient addresses
        address[] memory toAddress = new address[](2);
        toAddress[0] = address(0);
        toAddress[1] = address(2);

        vm.expectRevert("Invalid address");
        // Perform batch transfer
        batchTransfer.transferBatch(toAddress, amounts);    
        console.log('Zero address test passed');
    }

    function test_InsufficientBalance() public {
        uint contractBalanceBefore = myToken.balanceOf(address(batchTransfer));
        assertEq(contractBalanceBefore, totalSupply);

        // amounts to be transferred
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 2000;
        amounts[1] = 14000;
        
        // Recepient addresses
        address[] memory toAddress = new address[](2);
        toAddress[0] = address(1);
        toAddress[1] = address(2);

        vm.expectRevert("Insufficient balance");
        // Perform batch transfer
        batchTransfer.transferBatch(toAddress, amounts);    
        console.log('Insufficient balance test passed');
    }
}
