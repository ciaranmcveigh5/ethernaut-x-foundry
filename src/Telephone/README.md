# 4. Telephone

**NOTE** - Some code has been slightly altered to work with newer versions of solidity and enable us to test the level with foundry. Any where this has been done an accompanying comment gives context for why this change was made. 

**Original Level**

https://ethernaut.openzeppelin.com/level/0x0b6F6CE4BCfB70525A31454292017F640C10c768

## Walkthrough

https://medium.com/@nicolezhu/ethernaut-lvl-4-walkthrough-how-to-abuse-tx-origin-msg-sender-ef37d6751c8

## Foundry 

```
forge test --match-contract TelephoneTest -vvvv
```

![alt text](https://github.com/ciaranmcveigh5/ethernaut-x-foundry/blob/main/img/Telephone.png?raw=true)