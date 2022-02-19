// pragma solidity ^0.8.10;

// import "ds-test/test.sol";
// import "../DexTwo/DexTwo.sol";
// import "../DexTwo/DexTwoHack.sol";
// import "../DexTwo/DexTwoFactory.sol";
// import "../Ethernaut.sol";

// interface CheatCodes {
//   // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
//   function startPrank(address) external;
//   // Resets subsequent calls' msg.sender to be `address(this)`
//   function stopPrank() external;
// }

// contract DexTwoTest is DSTest {
//     CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
//     Ethernaut ethernaut;
//     DexTwoHack dexTwoHack;
//     DexTwoFactory dexTwoFactory;
//     address levelAddress;
//     bool levelSuccessfullyPassed;

//     function setUp() public {
//         // Setup instances of the Ethernaut & DexTwoFactory contracts
//         ethernaut = new Ethernaut();
//         dexTwoFactory = new DexTwoFactory();
//     }

//     function testDexTwoHack() public {

//         // Register the Ethernaut DexTwo level (this would have already been done on Rinkeby)
//         ethernaut.registerLevel(dexTwoFactory);

//         // Set up the Level
//         levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexTwoFactory);

//         // Cast the level address to the DexTwo contract class
//         DexTwo ethernautDexTwo = DexTwo(payable(levelAddress));

//         // Create DexTwoHack Contract
//         dexTwoHack = new DexTwoHack(ethernautDexTwo);
        
//         // give the attack contract the balance
//         IERC20(ethernautDexTwo.token1()).transfer(address(dexTwoHack), IERC20(ethernautDexTwo.token1()).balanceOf(address(this)));
//         IERC20(ethernautDexTwo.token2()).transfer(address(dexTwoHack), IERC20(ethernautDexTwo.token2()).balanceOf(address(this)));

//         // Call the attack function
//         dexTwoHack.attack();

//         // Submit level to the core Ethernaut contract
//         levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

//         // Verify the level has passed
//         assert(levelSuccessfullyPassed);
//     }
// }
