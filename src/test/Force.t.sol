pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../Force/ForceHack.sol";
import "../Force/ForceFactory.sol";
import "../Ethernaut.sol";

contract ForceTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testForceHack() public {

        /////////////////
        // LEVEL SETUP //
        /////////////////

        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create the attacking contract which will self destruct and send ether to the Force contract
        ForceHack forceHack = (new ForceHack){value: 0.1 ether}(payable(levelAddress));


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}