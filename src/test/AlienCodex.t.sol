pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";


contract AlienCodexTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testAlienCodexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        bytes memory bytecode = abi.encodePacked(vm.getCode("./src/AlienCodex/AlienCodex.json"));
        address alienCodex;

        // level needs to be deployed this way as it only works with 0.5.0 solidity version
        assembly {
            alienCodex := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        vm.startPrank(tx.origin);


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        /* testing solve branch */

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        (bool success, bytes memory data) = alienCodex.call(abi.encodeWithSignature("owner()"));

        // data is of type bytes32 so the address is padded, byte manipulation to get address
        address refinedData = address(uint160(bytes20(uint160(uint256(bytes32(data)) << 0))));

        vm.stopPrank();
        assertEq(refinedData, tx.origin);
    }
}