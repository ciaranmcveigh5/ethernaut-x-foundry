// pragma solidity ^0.8.10;

// import "ds-test/test.sol";
// import "../MagicNum/MagicNum.sol";
// import "../MagicNum/MagicNumFactory.sol";
// import "../Ethernaut.sol";

// interface CheatCodes {
//   // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called 
//   function startPrank(address) external;
//   // Resets subsequent calls' msg.sender to be `address(this)`
//   function stopPrank() external;
// }

// contract MagicNumTest is DSTest {
//     CheatCodes cheats = CheatCodes(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
//     Ethernaut ethernaut;
//     MagicNumFactory magicNumFactory;
//     address levelAddress;
//     bool levelSuccessfullyPassed;

//     function setUp() public {
//         // Setup instances of the Ethernaut & MagicNumFactory contracts
//         ethernaut = new Ethernaut();
//         magicNumFactory = new MagicNumFactory();
//     }

//     function testMagicNum() public {

//         // Register the Ethernaut MagicNum level (this would have already been done on Rinkeby)
//         ethernaut.registerLevel(magicNumFactory);

//         // Add some ETH to the 0 address which we will be using 
//         payable(address(0)).transfer(1 ether);
//         // Use the startPrank cheat which enables us to excute subsequent call as another address (https://onbjerg.github.io/foundry-book/reference/cheatcodes.html)
//         cheats.startPrank(address(0));

//         // Set up the Level
//         levelAddress = ethernaut.createLevelInstance(magicNumFactory);

//         // Cast the level address to the MagicNum contract class
//         MagicNum ethernautMagicNum = MagicNum(payable(levelAddress));

//         // INIT CODE
//         // 600a -- push 10 (runtime code size)
//         // 600c -- push 12 (runtime code start byte)
//         // 6000 -- push 0 (memory address to copy to)
//         // 39   -- codecopy
//         // 600a -- push amount of bytes to return
//         // 6000 -- memory address to start returning from
//         // f3   -- return 
//         // RUNTIME CODE
//         // 602a -- push value to return (42 in decimal)
//         // 6080 -- push mem address to store
//         // 52   -- mstore
//         // 6020 -- push number of bytes to return
//         // 6080 -- push mem address to return
//         // f3   -- return
//         bytes memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
//         address addr;
//         assembly {
//           addr := create(0, add(code, 0x20), mload(code))
//           if iszero(extcodesize(addr)) {
//             revert(0, 0)
//           }
//         }
//         ethernautMagicNum.setSolver(addr);

//         // Submit level to the core Ethernaut contract
//         levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));

//         // Stop the prank - calls with no longer come from address(0) 
//         cheats.stopPrank();

//         // Verify the level has passed
//         assert(levelSuccessfullyPassed);
//     }
// }
