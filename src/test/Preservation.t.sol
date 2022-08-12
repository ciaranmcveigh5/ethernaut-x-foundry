pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../Preservation/PreservationHack.sol";
import "../Preservation/PreservationFactory.sol";
import "../Ethernaut.sol";

contract PreservationTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testPreservationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        PreservationFactory preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(preservationFactory);
        Preservation ethernautPreservation = Preservation(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Move the block from 0 to 5 to prevent underflow errors
        vm.roll(5);

        // Create preservationHack contract
        PreservationHack preservationHack = new PreservationHack(levelAddress);

        // Run the attack
        preservationHack.attack();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
