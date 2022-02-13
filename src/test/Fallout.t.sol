pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Fallout/Fallout.sol";
import "../Fallout/FalloutFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract FalloutTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    FalloutFactory falloutFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & FalloutFactory contracts
        ethernaut = new Ethernaut();
        falloutFactory = new FalloutFactory();
    }

    function testFalloutHack() public {

        // Register the Ethernaut fallout level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(falloutFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));


        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(falloutFactory);

        // Cast the level address to the Fallout contract class
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        // Call Fal1out constructor function with some value, mispelling enables us to call it  
        ethernautFallout.Fal1out{value: 1 wei}();

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));


        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}