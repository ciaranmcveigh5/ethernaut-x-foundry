// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract King {

  address payable king;
  uint public prize;
  address payable public owner;

  constructor() public payable {
    owner = payable(msg.sender); // Type issue, must be payable address
    king = payable(msg.sender); // Type issue, must be payable address
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = payable(msg.sender); // Type issue, must be payable address
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}