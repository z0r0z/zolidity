// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import 'forge-std/Test.sol';
import './util/mock/MockRefunded.sol';

contract RefundedTest is Test {
    using stdStorage for StdStorage;

    MockRefunded immutable mock = new MockRefunded();

    function setUp() external payable {
        console.log(unicode'🧪 Testing Refunded...');
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
