// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {Tester} from "../src/Tester.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract TesterTest is Test {
    Tester internal tester;

    function setUp() public payable {
        // vm.createSelectFork(vm.rpcUrl('main')); // Ethereum mainnet fork.
        // vm.createSelectFork(vm.rpcUrl('base')); // Base OptimismL2 fork.
        // vm.createSelectFork(vm.rpcUrl('poly')); // Polygon network fork.
        // vm.createSelectFork(vm.rpcUrl('opti')); // Optimism EthL2 fork.
        // vm.createSelectFork(vm.rpcUrl('arbi')); // Arbitrum EthL2 fork.
        tester = new Tester();
    }

    function testTest() public payable {
        tester.test("ommm");
    }
}
