pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../GatekeeperTwo/GatekeeperTwoHack.sol";
import "../GatekeeperTwo/GatekeeperTwoFactory.sol";
import "../Ethernaut.sol";

contract GatekeeperTwoTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testGatekeeperTwoHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GatekeeperTwoFactory gatekeeperTwoFactory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(gatekeeperTwoFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperTwoFactory);
        GatekeeperTwo ethernautGatekeeperTwo = GatekeeperTwo(payable(levelAddress));
        vm.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////


        // Create attacking contract - attack is inside the constructor so no need to call any subsequent functions
        GatekeeperTwoHack gatekeeperTwoHack = new GatekeeperTwoHack(levelAddress);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        vm.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}