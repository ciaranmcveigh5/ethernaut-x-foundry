pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../Telephone/TelephoneHack.sol";
import "../Telephone/TelephoneFactory.sol";
import "../Ethernaut.sol";

contract TelephoneTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testTelephoneHack() public {

        /////////////////
        // LEVEL SETUP //
        /////////////////

        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(payable(levelAddress));


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create TelephoneHack contract
        TelephoneHack telephoneHack = new TelephoneHack(levelAddress);
        // Call the attack function
        telephoneHack.attack();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}