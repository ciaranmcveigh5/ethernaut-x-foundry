// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '../BaseLevel.sol';
import './Elevator.sol';

contract ElevatorFactory is Level {

  function createInstance(address _player) override public payable returns (address) {
    _player;
    Elevator instance = new Elevator();
    return address(instance);
  }

  function validateInstance(address payable _instance, address) override public returns (bool) {
    Elevator elevator = Elevator(_instance);
    return elevator.top();
  }

}