// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title BatchTransfer
 * @dev A contract for batch transferring ERC20 tokens to multiple addresses in a single transaction.
 */
contract BatchTransfer is Ownable, ReentrancyGuard {
    IERC20 public immutable token;
    uint64 private immutable batchLimit;

    /**
     * @dev Emitted when tokens are transferred from the contract to multiple receivers.
     * @param _sender The address of the contract.
     * @param _receiver The address of the receiver.
     * @param _amount The amount of tokens transferred.
     */
    event TokenTransfer(address _sender, address _receiver, uint _amount);

    /**
     * @dev Constructs the BatchTransfer contract.
     * @param _tokenAddress The address of the ERC20 token contract.
     * @param _batchLimit The maximum number of transfers allowed in a single batch.
     */
    constructor(address _tokenAddress, uint64 _batchLimit) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
        batchLimit = _batchLimit;
    }

    /**
     * @dev Transfers tokens to multiple addresses in a single batch.
     * @param _to An array of receiver addresses.
     * @param _amounts An array of amounts to be transferred to corresponding addresses.
     */
    function transferBatch(address[] calldata _to, uint256[] calldata _amounts) external onlyOwner nonReentrant {
        require(_to.length == _amounts.length, "Arrays length mismatch");
        // Batch limit added to protect transferBatch from denial of service attack (Sybil attack)
        require(_to.length <= batchLimit, "Exceeded batch limit");

        for (uint256 i = 0; i < _to.length; i++) {
            // Check required conditions
            require(_to[i] != address(0), "Invalid address");
            require(token.balanceOf(address(this)) >= _amounts[i], "Insufficient balance");

            // Emit token transfer event
            emit TokenTransfer(address(this), _to[i], _amounts[i]);

            // Transfer tokens to receiver address
            bool success = token.transfer(_to[i], _amounts[i]);
            require(success, 'Token transfer failed');
        }
    }
}
