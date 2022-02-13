pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../CoinFlip/CoinFlip.sol";
import "../CoinFlip/CoinFlipHack.sol";
import "../CoinFlip/CoinFlipFactory.sol";
import "../Ethernaut.sol";
import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol'; // Path change of openzeppelin contract


interface CheatCodes {
  function startPrank(address) external;
  function stopPrank() external;
  function roll(uint256) external;
}

contract CoinFlipTest is DSTest {
    CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    CoinFlipHack coinFlipHack;
    CoinFlipFactory coinFlipFactory;
    address levelAddress;
    bool levelSuccessfullyPassed;

    function setUp() public {
        // Setup instances of the Ethernaut & CoinFlipFactory contracts
        ethernaut = new Ethernaut();
        coinFlipFactory = new CoinFlipFactory();
    }

    function testCoinFlipHack() public {

        // Register the Ethernaut CoinFlip level (this would have already been done on Rinkeby)
        ethernaut.registerLevel(coinFlipFactory);

        // Add some ETH to the 0 address which we will be using 
        payable(address(0)).transfer(1 ether);

        // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
        cheats.startPrank(address(0));

        // Set up the Level
        levelAddress = ethernaut.createLevelInstance(coinFlipFactory);

        // Cast the level address to the CoinFlip contract class
        CoinFlip ethernautCoinFlip = CoinFlip(payable(levelAddress));

        // Move the block from 0 to 5 to prevent underflow errors
        cheats.roll(5);

        // Create coinFlipHack contract
        coinFlipHack = new CoinFlipHack(levelAddress);

        // Run the attack 10 times, iterate the block each time, function can only be called once per block
        for (uint i = 0; i <= 10; i++) {  
            cheats.roll(6 + i);
            coinFlipHack.attack();        
        }

        // Submit level to the core Ethernaut contract
        levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));


        // Stop the prank - calls with no longer come from address(0) 
        cheats.stopPrank();

        // Verify the level has passed
        assert(levelSuccessfullyPassed);
    }
}