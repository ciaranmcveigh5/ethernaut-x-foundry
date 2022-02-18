pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Force/ForceHack.sol";
import "../Force/ForceFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ForceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
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