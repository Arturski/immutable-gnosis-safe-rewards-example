# Gnosis Safe on Immutable zkEVM

## OVERVIEW

This detailed guide provides instructions for developers to create a multisig Gnosis Safe on Immutable X deploy custom smart contracts using Forge and Foundry tools and link these contracts through the Safe's interface. This example demonstrates how Safe can be used as a game rewards treasury.

## PROCEDURE

1. Create a folder called `gnosis-safe-rewards` and place both `.sol` files there.
2. Create Gnosis Safe wallet via [https://safe.immutable.com](https://safe.immutable.com) GUI.
3. Install foundry:
```bash
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
```
4. Deploy Rewards contract:
    ```bash
    forge create 
    --rpc-url "https://rpc.testnet.immutable.com" 
    --private-key "<PrivateKey>" 
    gnosis-safe-rewards/Rewards.sol:Rewards
    ```
5. Deploy Safe Module:
    ```bash
    forge create 
    --rpc-url "https://rpc.testnet.immutable.com" 
    --private-key "<PrivateKey>" 
    --constructor-args "<SafeAddress>" 
    gnosis-safe-rewards/RewardsSafeModule.sol:RewardsSafeModule
    ```
6. Update Rewards contract with Safe Module contract address:
    ```bash
    cast send --rpc-url "https://rpc.testnet.immutable.com"    
    --private-key "<PrivateKey>"            
    "<RewardsSafeModuleContractAddress>" 
    "setRewardsContract(address)" 
      "<RewardsContractAddress>"
    ```
7. Update Safe Module contract with Rewards contract address:
    ```bash
    cast send --rpc-url "https://rpc.testnet.immutable.com"    
    --private-key "<PrivateKey>" 
    "<RewardsContractAddress>"      
    "setSafeModule(address)" 
    "<RewardsSafeModuleContractAddress>"
    ```

## Enable safe module
- Find the Gnosis Safe master contract you can do this in Blockscout.

## Add Transaction Builder to your Safe via this guide
- Enable Module using the Transaction Builder and this guide

## RISKS AND CONSIDERATIONS
These contracts are implemented only as concept examples and are not audited. When following this guide you must make security and scalability considerations that fit the desired outcomes of the project under production conditions.

## REFERENCES
- Safe Getting Started: [https://help.safe.global/en/collections/9801-getting-started](https://help.safe.global/en/collections/9801-getting-started)
- Transaction Builder: [https://help.safe.global/en/articles/40841-transaction-builder](https://help.safe.global/en/articles/40841-transaction-builder)
- Add a module using Transaction Builder: [https://help.safe.global/en/articles/40826-add-a-module](https://help.safe.global/en/articles/40826-add-a-module)