pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperTwo/GatekeeperTwoHack.sol";
import "../GatekeeperTwo/GatekeeperTwoFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract GatekeeperTwoTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
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