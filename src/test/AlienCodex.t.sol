pragma solidity ^0.8.10;

import "ds-test/test.sol";
// import "../AlienCodex/AlienCodexFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";


contract AlienCodexTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    event Response(bool success, bytes data);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testAlienCodexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        bytes memory bytecode = abi.encodePacked(vm.getCode("./src/AlienCodex/AlienCodexFactory.json"));
        address addr;

        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        (bool success, bytes memory data) = addr.call(abi.encodeWithSignature("contact()"));

        emit Response(success, data);

        (success, data) = addr.call(abi.encodeWithSignature("owner()"));

        emit Response(success, data);


        // AlienCodex ethernautAlienCodex = AlienCodex(payable(addr));

        // AlienCodexFactory alienCodexFactory = new AlienCodexFactory();
        // ethernaut.registerLevel(addr);
        // vm.startPrank(eoaAddress);
        // address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(addr);
        // AlienCodex ethernautAlienCodex = AlienCodex(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        // cheats.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}