// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '../BaseLevel.sol';
import './Switch.sol';

contract SwitchFactory is Level {

  function createInstance(address _player) override public payable returns (address) {
    Switch switch_instance = new Switch();
    return address(switch_instance);
  }

  function validateInstance(address payable _instance, address) override public returns (bool) {
    return Switch(_instance).switchOn();
  }

}
