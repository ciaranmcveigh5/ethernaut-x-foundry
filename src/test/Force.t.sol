pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Force/Force.sol";
import "../Force/ForceHack.sol";
import "../Force/ForceFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract ForceTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    ForceHack forceHack;
    ForceFactory forceFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & ForceFactory contracts
        ethernaut = new Ethernaut();
        forceFactory = new ForceFactory();
    }

    function testForceHack() public {

        // Register the Ethernaut Force level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(forceFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(forceFactory);

        // Cast the level address to the Force contract class
        Force ethernautForce = Force(payable(levelAddress));

        // Create the attacking contract which will self destruct and send ether to the Force contract
        forceHack = (new ForceHack){value: 0.1 ether}(payable(levelAddress));

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}