pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../DexTwo/DexTwoHack.sol";
import "../DexTwo/DexTwoFactory.sol";
import "../Ethernaut.sol";

contract DexTwoTest is DSTest {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testDexTwoHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexTwoFactory);
        DexTwo ethernautDexTwo = DexTwo(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create DexTwoHack Contract
        DexTwoHack dexTwoHack = new DexTwoHack(ethernautDexTwo);
        
        // give the attack contract the balance
        IERC20(ethernautDexTwo.token1()).transfer(address(dexTwoHack), IERC20(ethernautDexTwo.token1()).balanceOf(address(this)));
        IERC20(ethernautDexTwo.token2()).transfer(address(dexTwoHack), IERC20(ethernautDexTwo.token2()).balanceOf(address(this)));

        // Call the attack function
        dexTwoHack.attack();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        assert(levelSuccessfullyPassed);
    }
}
