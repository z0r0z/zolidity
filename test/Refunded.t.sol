// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "./util/mock/MockRefunded.sol";

/// @dev VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol,
/// or at https://github.com/foundry-rs/forge-std

contract RefundedTest is Test {
    using stdStorage for StdStorage;

    MockRefunded immutable mock = new MockRefunded();

    constructor() payable {}

    function setUp() external payable {
        console.log(unicode"🧪 Testing Refunded...");
    }

    function testDeploy() external payable {
        new MockRefunded();
    }

    function testRefunded() external payable {
        mock.foo();
    }

    function testUnrefunded() external payable {
        mock.bar();
    }
}
