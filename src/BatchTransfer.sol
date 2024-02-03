// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BatchTransfer is Ownable, ReentrancyGuard {
    IERC20 public token;

    event TokenTransfer(address _sender, address _receiver, uint _amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
    }

    function transferBatch(address[] calldata _to, uint256[] calldata _amounts) external onlyOwner nonReentrant {
        require(_to.length == _amounts.length, "Arrays length mismatch");

        for (uint256 i = 0; i < _to.length; i++) {
            // Check required conditions
            require(_to[i] != address(0), "Invalid address");
            require(token.balanceOf(address(this)) >= _amounts[i], "Insufficient balance");

            // Emit token transfer event
            emit TokenTransfer(address(this), _to[i], _amounts[i]);

            // Transfer tokens to receiver address
            token.transfer(_to[i], _amounts[i]);
        }
    }
}
