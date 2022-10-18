// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {MockRefunded} from "./utils/mocks/MockRefunded.sol";

import "@std/Test.sol";

contract RefundedTest is Test {
    using stdStorage for StdStorage;

    MockRefunded mock;

    function setUp() public {
        console.log(unicode"🧪 Testing Refunded...");

        mock = new MockRefunded();
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // Or at https://github.com/foundry-rs/forge-std
    function testDeploy() public {
        new MockRefunded();
    }

    function testRefunded() public {
        mock.foo();
    }

    function testUnrefunded() public {
        mock.bar();
    }
}
