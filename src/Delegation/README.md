# 6. Delegation

**NOTE** - Some code has been slightly altered to work with newer versions of solidity and enable us to test the level with foundry. Any where this has been done an accompanying comment gives context for why this change was made. 

**Original Level**

https://ethernaut.openzeppelin.com/level/0x9451961b7Aea1Df57bc20CC68D72f662241b5493

## Walkthrough

https://medium.com/coinmonks/ethernaut-lvl-6-walkthrough-how-to-abuse-the-delicate-delegatecall-466b26c429e4

## Foundry 

```
forge test --match-contract DelegationTest -vvvv
```

![alt text](https://github.com/ciaranmcveigh5/ethernaut-x-foundry/blob/main/img/Delegation.png?raw=true)