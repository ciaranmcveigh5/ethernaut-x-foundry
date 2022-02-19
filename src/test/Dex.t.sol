// pragma solidity ^0.8.10;

// import "ds-test/test.sol";
// import "../Dex/DexHack.sol";
// import "../Dex/DexFactory.sol";
// import "../Ethernaut.sol";
// import "./utils/vm.sol";

// contract DexTest is DSTest {
//     Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
//     Ethernaut ethernaut;

//     function setUp() public {
//         // Setup instance of the Ethernaut contracts
//         ethernaut = new Ethernaut();
//     }

//     function testDexHack() public {
//         /////////////////
//         // LEVEL SETUP //
//         /////////////////

//         DexFactory dexFactory = new DexFactory();
//         ethernaut.registerLevel(dexFactory);
//         vm.startPrank(tx.origin);
//         address levelAddress = ethernaut.createLevelInstance(dexFactory);
//         Dex ethernautDex = Dex(payable(levelAddress));

//         //////////////////
//         // LEVEL ATTACK //
//         //////////////////

//         // Create DexHack Contract
//         DexHack dexHack = new DexHack(ethernautDex);
        
//         // give the attack contract the balance
//         IERC20(ethernautDex.token1()).transfer(address(dexHack), IERC20(ethernautDex.token1()).balanceOf(address(this)));
//         IERC20(ethernautDex.token2()).transfer(address(dexHack), IERC20(ethernautDex.token2()).balanceOf(address(this)));

//         // Call the attack function
//         dexHack.attack();


//         //////////////////////
//         // LEVEL SUBMISSION //
//         //////////////////////

//         bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
//         vm.stopPrank();
//         assert(levelSuccessfullyPassed);
//     }
// }
