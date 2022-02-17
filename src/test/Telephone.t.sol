pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Telephone/TelephoneHack.sol";
import "../Telephone/TelephoneFactory.sol";
import "../Ethernaut.sol";


interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called  
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract TelephoneTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
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
        cheats.startPrank(tx.origin);
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
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}