// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {MockEpoch} from "./utils/mocks/MockEpoch.sol";

import "@std/Test.sol";

contract StatelessEpochTest is Test {
    using stdStorage for StdStorage;

    MockEpoch mock;

    function setUp() public {
        console.log(unicode"🧪 Testing StatlessEpoch...");
        
        mock = new MockEpoch();

        // incrementing epoch 0 to 1 costs 22,247 gas
        mock.incrementEpoch();

        // incrementing epoch 1 to 2 costs 11,297 gas
        mock.incrementEpoch();

        // incrementing epochCounter[2] from 0 to 1 costs 22,469 gas 
        mock.useEpoch();

        // incrementing epochCounter[2534796] from 0 to 1 costs 22,435 gas
        mock.useStatelessEpoch();
    }

    function testEpoch() public {
        mock.useEpoch();
    }

    function testStatelessEpoch() public {
        mock.useStatelessEpoch();
    }
    // function testA() public {
    //     mock.useStatelessEpoch();
    //     mock.useEpoch();
    // }
    // function testB() public {
    //     mock.useEpoch();
    //     mock.useStatelessEpoch();
    // }
}
