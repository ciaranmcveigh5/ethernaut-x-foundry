
   
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./PuzzleWallet.sol";

contract PuzzleWalletFactory {
  event NewWallet(address indexed wallet);

  /**
   * @dev Creates and initializes a PuzzleWallet instance
   */
  function createInstance() public payable returns (address proxy, address instance) {
    require(msg.value == 1 ether, "Must send 1 ETH to create instance");

    // deploy the PuzzleWallet logic
    PuzzleWallet walletLogic = new PuzzleWallet();

    // deploy proxy and initialize implementation contract
    bytes memory data = abi.encodeWithSelector(
      PuzzleWallet.init.selector,
      100 ether
    );
    PuzzleProxy proxy = new PuzzleProxy(
      address(this),
      address(walletLogic),
      data
    );
    PuzzleWallet instance = PuzzleWallet(address(proxy));

    // whitelist this contract to allow it to deposit ETH
    instance.addToWhitelist(address(this));
    instance.deposit{value: msg.value}();

    emit NewWallet(address(proxy));
    return (address(proxy), address(instance));
  }
}