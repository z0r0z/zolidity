// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "@forge/Test.sol";
import {ReentrancyGuard} from "../src/ReentrancyGuard.sol";

contract MockReentrant is ReentrancyGuard {
    uint256 public counter;

    function protectedFunction() external nonReentrant {
        counter++;
        if (counter == 1) this.protectedFunction();
    }

    function unprotectedFunction() external {
        counter++;
        if (counter == 1) this.unprotectedFunction();
    }

    function getReentrancyGuard() external view returns (uint256 value) {
        bytes32 slot = keccak256("zolidity.reentrancy.lock");
        assembly {
            // Load the transient storage value
            value := tload(slot)
        }
    }
}

contract ReentrancyGuardTest is Test {
    MockReentrant mock;

    function setUp() public {
        mock = new MockReentrant();
    }

    function testProtectedFunctionPreventsReentrancy() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        mock.protectedFunction();
    }

    function testUnprotectedFunctionAllowsReentrancy() public {
        mock.unprotectedFunction();
        assertEq(mock.counter(), 2);
    }

    function testGuardValueReset() public {
        try mock.protectedFunction() {} catch {}
        uint256 slotvalue = mock.getReentrancyGuard();
        assertEq(slotvalue, 0, "Guard should be reset to 0");
    }
}
