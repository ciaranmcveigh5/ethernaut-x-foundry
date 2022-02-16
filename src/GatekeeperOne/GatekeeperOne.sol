// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol'; // Path change of openzeppelin contract

contract GatekeeperOne {

  using SafeMath for uint256;
  address public entrant;

  event Who(address _value);

  event Number64(uint64 _value);
  event Number32(uint32 _value);
  event Number16(uint16 _value);
  event Bits64(bytes8 _value);

  modifier gateOne() {
    emit Who(msg.sender);
    emit Who(tx.origin);
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft().mod(8191) == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      emit Bits64(_gateKey);
      emit Number32(uint32(uint64(_gateKey)));
      emit Number16(uint16(uint64(_gateKey)));
      emit Number64(uint64(_gateKey));
      emit Number16(uint16(uint160(tx.origin)));
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}