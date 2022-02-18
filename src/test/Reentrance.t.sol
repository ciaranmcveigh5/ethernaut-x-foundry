pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Reentrance/ReentranceHack.sol";
import "../Reentrance/ReentranceFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ReentranceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 3 ether);
    }

    function testReentranceHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(reentranceFactory);
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create ReentranceHack contract
        ReentranceHack reentranceHack = new ReentranceHack(levelAddress);

        // Call the attack function to drain the contract
        reentranceHack.attack{value: 0.4 ether}();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}