# ethernaut-x-foundry

## Ethernaut puzzles solved & tested with foundry.

**Ethernaut**

https://ethernaut.openzeppelin.com/

**Foundry**

https://github.com/gakonst/foundry


## Info

This repo is setup to enable you to run the ethernaut levels locally rather than on Rinkeby. As a result you will see some contracts that are not related to individual level but instead to ethernaut's core contracts which determine if you have passed the level. 

These are the Ethernaut.sol & BaseLevel.sol contracts in the root of ./src and the factory contracts which have a naming convention of [LEVEL_NAME]Factory.sol in each levels repo. Have a read through if interested in what they do otherwise they can be ignored.

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




## References

https://github.com/MrToph/ethernaut

