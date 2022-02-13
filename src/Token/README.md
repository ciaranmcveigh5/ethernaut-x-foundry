# 5. Token

**NOTE** - Some code has been slightly altered to work with newer versions of solidity and enable us to test the level with foundry. Any where this has been done an accompanying comment gives context for why this change was made. 

**Original Level**

https://ethernaut.openzeppelin.com/level/0x63bE8347A617476CA461649897238A31835a32CE

## Walkthrough

https://medium.com/coinmonks/ethernaut-lvl-5-walkthrough-how-to-abuse-arithmetic-underflows-and-overflows-2c614fa86b74

## Foundry 

```
forge test --match-contract TokenTest -vvvv
```

![alt text](https://github.com/ciaranmcveigh5/ethernaut-x-foundry/blob/main/img/Token.png?raw=true)