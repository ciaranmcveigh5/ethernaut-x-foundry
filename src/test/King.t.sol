pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../King/King.sol";
import "../King/KingHack.sol";
import "../King/KingFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract KingTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    KingHack kingHack;
    KingFactory kingFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & KingFactory contracts
        ethernaut = new Ethernaut();
        kingFactory = new KingFactory();
    }

    function testKingHack() public {

        // Register the Ethernaut King level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(kingFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(3 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);

        // Cast the level address to the King contract class
        King ethernautKing = King(payable(levelAddress));

        // Create KingHack Contract
        kingHack = new KingHack(payable(levelAddress));

        // Call the attack function the recieve function in the KingHack contract will prevent others from becoming king
        kingHack.attack{value: 1 ether}();

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}