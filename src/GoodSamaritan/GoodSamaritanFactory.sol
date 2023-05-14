// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '../BaseLevel.sol';
import './GoodSamaritan.sol';
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract GoodSamaritanFactory is Level {

  function createInstance(address _player) override public payable returns (address) {
    GoodSamaritan samaritan_instance = new GoodSamaritan();
    return address(samaritan_instance);
  }

  function validateInstance(address payable _instance, address) override public returns (bool) {
    Coin coin = GoodSamaritan(_instance).coin();
    address wallet = address(GoodSamaritan(_instance).wallet());
    return coin.balances(wallet) == 0;
  }

}
