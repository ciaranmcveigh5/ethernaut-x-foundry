// pragma solidity ^0.8.10;

// import "ds-test/test.sol";
// import "../Shop/Shop.sol";
// import "../Shop/ShopHack.sol";
// import "../Shop/ShopFactory.sol";
// import "../Ethernaut.sol";

// interface CheatCodes {
//   // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
//   function startPrank(address) external;
//   // Resets subsequent calls' msg.sender to be `address(this)`
//   function stopPrank() external;
// }

// contract ShopTest is DSTest {
//     CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
//     Ethernaut ethernaut;
//     ShopHack shopHack;
//     ShopFactory shopFactory;
//     address levelAddress;
//     bool levelSuccessfullyPassed;

//     function setUp() public {
//         // Setup instances of the Ethernaut & ShopFactory contracts
//         ethernaut = new Ethernaut();
//         shopFactory = new ShopFactory();
//     }

//     function testShopHack() public {

//         // Register the Ethernaut Shop level (this would have already been done on Rinkeby)
//         ethernaut.registerLevel(shopFactory);

//         // Add some ETH to the 0 address which we will be using 
//         payable(address(0)).transfer(1 ether);
//         // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
//         cheats.startPrank(address(0));

//         // Set up the Level
//         levelAddress = ethernaut.createLevelInstance(shopFactory);

//         // Cast the level address to the Shop contract class
//         Shop ethernautShop = Shop(payable(levelAddress));

//         // Create ShopHack Contract
//         shopHack = new ShopHack(ethernautShop);

//         // attack Shop contract.
//         shopHack.attack();

//         // Submit level to the core Ethernaut contract
//         levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

//         // Stop the prank - calls with no longer come from address(0) 
//         cheats.stopPrank();

//         // Verify the level has passed
//         assert(levelSuccessfullyPassed);
//     }
// }
