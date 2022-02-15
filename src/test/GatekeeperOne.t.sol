pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperOne/GatekeeperOne.sol";
import "../GatekeeperOne/GatekeeperOneHack.sol";
import "../GatekeeperOne/GatekeeperOneFactory.sol";
import "../Ethernaut.sol";


interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input  
  function startPrank(address, address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract GatekeeperOneTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    GatekeeperOneHack gatekeeperOneHack;
    GatekeeperOneFactory gatekeeperOneFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & GatekeeperOneFactory contracts
        ethernaut = new Ethernaut();
        gatekeeperOneFactory = new GatekeeperOneFactory();
    }

    function testGatekeeperOneHack() public {

        // Register the Ethernaut GatekeeperOne level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(gatekeeperOneFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);

        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0), address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);

        // Cast the level address to the GatekeeperOne contract class
        GatekeeperOne ethernautGatekeeperOne = GatekeeperOne(payable(levelAddress));


        // Create GatekeeperOneHack contract
        gatekeeperOneHack = new GatekeeperOneHack(levelAddress);

        // Call the attack function
        gatekeeperOneHack.attack(bytes8(abi.encode(uint16(uint160(tx.origin)))), 56348);

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));


        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}