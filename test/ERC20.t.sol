// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "./util/mock/MockERC20.sol";

/// @dev VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol,
/// or at https://github.com/foundry-rs/forge-std

contract ERC20Test is Test {
    using stdStorage for StdStorage;

    MockERC20 immutable tkn = new MockERC20();
    address immutable alice = vm.addr(1);
    address immutable bob = vm.addr(2);

    constructor() payable {}

    function setUp() external payable {
        console.log(unicode"🧪 Testing ERC20...");
        tkn.mint(address(this), 100 ether);
    }

    function testTransfer() external payable {
        tkn.transfer(alice, 10 ether);
    }
}
