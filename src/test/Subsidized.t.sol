// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {MockSubsidized} from './utils/mocks/MockSubsidized.sol';

import "@std/Test.sol";

contract SubsidizedTest is Test {
    using stdStorage for StdStorage;

    MockSubsidized mock;

    function setUp() public {
        console.log(unicode"🧪 Testing Subsidizer...");
        
        mock = new MockSubsidized();
    }

    // VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    // Or at https://github.com/foundry-rs/forge-std
    function testSubsidized() public {
        mock.foo();
        
        console.log(unicode"✅ subsidized test passed!");
    }

    function testUnsubsidized() public {
        mock.bar();
        
        console.log(unicode"✅ unsubsidized test passed!");
    }
}
