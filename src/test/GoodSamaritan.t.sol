pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GoodSamaritan/GoodSamaritanHack.sol";
import "../GoodSamaritan/GoodSamaritanFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";


contract GoodSamaritanTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testGoodSamaritanHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GoodSamaritanFactory goodSamaritanFactory = new GoodSamaritanFactory();
        ethernaut.registerLevel(goodSamaritanFactory);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(goodSamaritanFactory);
        GoodSamaritan ethernautGoodSamaritan = GoodSamaritan(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create GoodSamaritanHack Contract
        GoodSamaritanHack goodSamaritanHack = new GoodSamaritanHack(address(ethernautGoodSamaritan));
        
        // Attack the contract and trigger an error with the right hash
        goodSamaritanHack.attack();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        assert(levelSuccessfullyPassed);
    }
}
