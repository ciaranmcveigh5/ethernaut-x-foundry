// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '../BaseLevel.sol';
import './Fallout.sol';

contract FalloutFactory is Level {

  function createInstance(address _player) override public payable returns (address) {
    _player;
    Fallout instance = new Fallout();
    return address(instance);
  }

  function validateInstance(address payable _instance, address _player) override public view returns (bool) {
    Fallout instance = Fallout(_instance);
    return instance.owner() == _player;
  }
}
