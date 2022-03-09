// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '../BaseLevel.sol';
import './Token.sol';

contract TokenFactory is Level {

  uint supply = 21000000;
  uint playerSupply = 20;

  function createInstance(address _player) override public payable returns (address) {
    Token token = new Token(supply);
    token.transfer(_player, playerSupply);
    return address(token);
  }

  function validateInstance(address payable _instance, address _player) override public view returns (bool) {
    Token token = Token(_instance);
    return token.balanceOf(_player) > playerSupply;
  }
}
