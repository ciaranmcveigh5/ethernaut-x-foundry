pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Dex/Dex.sol";
import "../Dex/DexHack.sol";
import "../Dex/DexFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract DexTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    DexHack dexHack;
    DexFactory dexFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & DexFactory contracts
        ethernaut = new Ethernaut();
        dexFactory = new DexFactory();
    }

    function testDexHack() public {

        // Register the Ethernaut Dex level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(dexFactory);

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexFactory);

        // Cast the level address to the Dex contract class
        Dex ethernautDex = Dex(payable(levelAddress));

        // Create DexHack Contract
        dexHack = new DexHack(ethernautDex);
        
        // give the attack contract the balance
        IERC20(ethernautDex.token1()).transfer(address(dexHack), IERC20(ethernautDex.token1()).balanceOf(address(this)));
        IERC20(ethernautDex.token2()).transfer(address(dexHack), IERC20(ethernautDex.token2()).balanceOf(address(this)));

        // Call the attack function
        dexHack.attack();

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}
