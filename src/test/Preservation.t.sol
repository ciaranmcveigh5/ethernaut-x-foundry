pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Preservation/Preservation.sol";
import "../Preservation/PreservationAttack.sol";
import "../Preservation/PreservationFactory.sol";
import "../Ethernaut.sol";


interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called  
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Set block.number
  function roll(uint256) external;
}

contract PreservationTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    PreservationAttack preservationAttack;
    PreservationFactory preservationFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & PreservationFactory contracts
        ethernaut = new Ethernaut();
        preservationFactory = new PreservationFactory();
    }

    function testPreservationAttack() public {

        // Register the Ethernaut Preservation level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(preservationFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);

        // Use the startPrank cheat which enables us to execute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(preservationFactory);

        // Move the block from 0 to 5 to prevent underflow errors
        cheats.roll(5);

        // Create preservationAttack contract
        preservationAttack = new PreservationAttack(levelAddress);

        // Run the attack
        preservationAttack.attack();        

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}
