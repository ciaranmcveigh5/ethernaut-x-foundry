pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Elevator/ElevatorHack.sol";
import "../Elevator/ElevatorFactory.sol";
import "../Ethernaut.sol";

contract ElevatorTest is DSTest {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testElevatorHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        address levelAddress = ethernaut.createLevelInstance(elevatorFactory);
        Elevator ethernautElevator = Elevator(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create ElevatorHack contract
        ElevatorHack elevatorHack = new ElevatorHack(levelAddress);

        // Call the attack function
        elevatorHack.attack();


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        assert(levelSuccessfullyPassed);
    }
}