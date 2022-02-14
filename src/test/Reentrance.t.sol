pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Reentrance/Reentrance.sol";
import "../Reentrance/ReentranceHack.sol";
import "../Reentrance/ReentranceFactory.sol";
import "../Ethernaut.sol";


interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input  
  function startPrank(address, address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract ReentranceTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    ReentranceHack reentranceHack;
    ReentranceFactory reentranceFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & ReentranceFactory contracts
        ethernaut = new Ethernaut();
        reentranceFactory = new ReentranceFactory();
    }

    function testReentranceHack() public {

        // Register the Ethernaut Reentrance level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(reentranceFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(3 ether);

        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0), address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance{value: 1 ether}(reentranceFactory);

        // Cast the level address to the Reentrance contract class
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));

        // Create ReentranceHack contract
        reentranceHack = new ReentranceHack(levelAddress);

        // Call the attack function
        reentranceHack.attack{value: 0.4 ether}();

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));


        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}