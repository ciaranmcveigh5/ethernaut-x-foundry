pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperTwo/GatekeeperTwoHack.sol";
import "../GatekeeperTwo/GatekeeperTwoFactory.sol";
import "../Ethernaut.sol";


interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input  
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Sets an address' balance
  function deal(address who, uint256 newBalance) external;
}

contract GatekeeperTwoTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        cheats.deal(eoaAddress, 5 ether);
    }

    function testGatekeeperTwoHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GatekeeperTwoFactory gatekeeperTwoFactory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(gatekeeperTwoFactory);
        cheats.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperTwoFactory);
        GatekeeperTwo ethernautGatekeeperTwo = GatekeeperTwo(payable(levelAddress));
        cheats.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////

    
        // Create attacking contract - attack is inside the constructor so no need to call any subsequent functions
        GatekeeperTwoHack gatekeeperTwoHack = new GatekeeperTwoHack(levelAddress);
        

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        cheats.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}