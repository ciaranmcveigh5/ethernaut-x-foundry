// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol'; // Path change of openzeppelin contract

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      unchecked {
        balances[msg.sender] -= _amount; // unchecked to prevent underflow errors
      }
    }
  }

  receive() external payable {}
}