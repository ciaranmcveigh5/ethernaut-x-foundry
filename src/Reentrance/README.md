# 10. Reentrance

**NOTE** - Some code has been slightly altered to work with newer versions of solidity and enable us to test the level with foundry. Any where this has been done an accompanying comment gives context for why this change was made. 

**Original Level**

https://ethernaut.openzeppelin.com/level/0xe6BA07257a9321e755184FB2F995e0600E78c16D

## Walkthrough

https://medium.com/coinmonks/ethernaut-lvl-10-re-entrancy-walkthrough-how-to-abuse-execution-ordering-and-reproduce-the-dao-7ec88b912c14

## Foundry 

```
forge test --match-contract ReentranceTest -vvvv
```

![alt text](https://github.com/ciaranmcveigh5/ethernaut-x-foundry/blob/main/img/Reentrance.png?raw=true)