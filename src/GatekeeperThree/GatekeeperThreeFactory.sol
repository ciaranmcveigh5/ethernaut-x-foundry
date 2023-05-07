// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import '../BaseLevel.sol';
import './GatekeeperThree.sol';

contract GatekeeperThreeFactory is Level {

  function createInstance(address _player) override public payable returns (address) {
    GatekeeperThree gatekeeper_instance = new GatekeeperThree();
    return address(gatekeeper_instance);
  }

  function validateInstance(address payable _instance, address) override public returns (bool) {
    return GatekeeperThree(_instance).entrant() == tx.origin;
  }

}
