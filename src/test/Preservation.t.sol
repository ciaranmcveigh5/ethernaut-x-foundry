pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Preservation/PreservationHack.sol";
import "../Preservation/PreservationFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract PreservationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
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
