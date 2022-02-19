pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../MagicNum/MagicNumFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract MagicNumTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testMagicNum() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        MagicNumFactory magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(magicNumFactory);
        MagicNum ethernautMagicNum = MagicNum(payable(levelAddress));


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // INIT CODE
        // 600a -- push 10 (runtime code size)
        // 600c -- push 12 (runtime code start byte)
        // 6000 -- push 0 (memory address to copy to)
        // 39   -- codecopy
        // 600a -- push amount of bytes to return
        // 6000 -- memory address to start returning from
        // f3   -- return 
        // RUNTIME CODE
        // 602a -- push value to return (42 in decimal)
        // 6080 -- push mem address to store
        // 52   -- mstore
        // 6020 -- push number of bytes to return
        // 6080 -- push mem address to return
        // f3   -- return

        bytes memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address addr;
        assembly {
          addr := create(0, add(code, 0x20), mload(code))
          if iszero(extcodesize(addr)) {
            revert(0, 0)
          }
        }
        ethernautMagicNum.setSolver(addr);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
