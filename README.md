# ethernaut-x-foundry

## Ethernaut puzzles solved & tested with foundry.

**Ethernaut**

https://ethernaut.openzeppelin.com/

**Foundry**

https://github.com/foundry-rs/foundry

## Setup 

@0xEval has written an excellent run through of how the repo is configured and how to get setup on it.

https://eval.hashnode.dev/ethernaut-x-foundry-0x0-hello-ethernaut

## Info

This repo is setup to enable you to run the ethernaut levels locally rather than on Rinkeby. As a result you will see some contracts that are not related to individual level but instead to ethernaut's core contracts which determine if you have passed the level. 

These are the Ethernaut.sol & BaseLevel.sol contracts in the root of ./src and the factory contracts which have a naming convention of [LEVEL_NAME]Factory.sol in each levels repo. Have a read through if interested in what they do otherwise they can be ignored.


Make sure you're on the latest version of forge, what is your forge —version output? 
If it doesn’t show a date, try rm -rf ~/.cargo/bin/cast && rm -rf ~/.cargo/bin/forge


At the root of the repo run

```
foundryup 
forge install 
forge test
```

**File Locations**

Individual Levels can be found in their respective folders in the ./src folder.  

Eg [Fallback is located in ./src/Fallback/Fallback.sol](src/Fallback/Fallback.sol)


Tests for each level can be found in the ./src/test folder and have the naming convention [LEVEL_NAME].t.sol 

Eg [Fallback test are located in ./src/test/Fallback.t.sol](src/test/Fallback.t.sol)


## Levels

| Level | 
| ------------- |
| [1. Fallback](src/Fallback) |
| [2. Fallout](src/Fallout) |
| [3. CoinFlip](src/CoinFlip) |
| [4. Telephone](src/Telephone) |
| [5. Token](src/Token) |
| [6. Delegation](src/Delegation) |
| [7. Force](src/Force) |
| [8. Vault](src/Vault) |
| [9. King](src/King) |
| [10. Re-Entrancy](src/Reentrance) |
| [11. Elevator](src/Elevator) |
| [12. Privacy](src/Privacy) |
| [13. GatekeeperOne](src/GatekeeperOne) |
| [14. GatekeeperTwo](src/GatekeeperTwo) |
| [15. NaughtCoin](src/NaughtCoin) |
| [16. Preservation](src/Preservation) |
| [17. Recovery](src/Recovery) |
| [18. Magic Number](src/MagicNum) |
| [19. AlienCodex](src/AlienCodex) |
| [20. Denial](src/Denial) |
| [21. Shop](src/Shop) |
| [22. Dex](src/Dex) |
| [23. Dex Two](src/DexTwo) |
| [24. PuzzleWallet](src/PuzzleWallet) |
| [25. Motorbike](src/Motorbike) |

## References

@cmichelio for his hardhat x ethernaut repo
https://github.com/MrToph/ethernaut

@0xSage for his great ethernaut tutorials - breaking down how each level can be defeated
https://medium.com/hackernoon/ethernaut-lvl-0-walkthrough-abis-web3-and-how-to-abuse-them-d92a8842d71b

@gakonst for his help on the foundry support channels and the tool itself
https://github.com/gakonst/foundry

@the_ethernaut for the puzzles to solve & learn from
https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008



