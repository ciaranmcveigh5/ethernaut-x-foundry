# 25. Motorbike

**NOTE** - Because of the way foundry test work it is very hard to verify this test was successful, Selfdestruct is a substate (see pg 8 https://ethereum.github.io/yellowpaper/paper.pdf). This means it gets executed at the end of a transaction, a single test is a single transaction. This means we can call selfdestruct on the engine contract at the start of the test but we will continue to be allowed to call all other contract function for the duration of that transaction (test) since the selfdestruct execution only happy at the end  

**Original Level**

https://ethernaut.openzeppelin.com/level/0x78e23A3881e385465F19c1a03E2F9fFEBdAD6045

## Walkthrough

https://www.youtube.com/watch?v=WdiCzB3zjy0&t=297s&ab_channel=Digibard

## Foundry 

```
forge test --match-contract MotorbikeTest -vvvv
```

![alt text](https://github.com/ciaranmcveigh5/ethernaut-x-foundry/blob/main/img/Motorbike.png?raw=true)