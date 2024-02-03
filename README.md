# CHALLENGE 2: POLYGON BLOCKCHAIN TRANSACTION OPTIMIZATION 
## Problem: 
Write a Solidity function ‘transferBatch(address[] calldata _to, uint256[]
calldata _amounts)’ in a new smart contract that can perform multiple transfers in a
single transaction on the Polygon blockchain to optimize gas cost. The function
should perform a safety check that _to and _amounts arrays have the same length.

## Sample Inputs and Outputs:
### Input: 
`transferBatch(["0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B",
"0x4E83362442B8d1bec281594CEA3050c8EB01311C"], [100, 200])`

### Output:
`100 tokens transferred to address
"0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B" and 200 tokens
transferred to address "0x4E83362442B8d1bec281594CEA3050c8EB01311C".`

## Test Case:
1. Execute the ‘transferBatch()’ function with valid addresses and amounts.
1. Verify if the correct amount of tokens has been transferred to each address.

## Foundry Details:

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Pre-Requisite

[Foundry Installation](https://book.getfoundry.sh/getting-started/installation)

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test -vv
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil - spin up local test network

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/BatchTransfer.s.sol:BatchTransferScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
