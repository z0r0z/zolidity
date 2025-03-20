// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {SoladyTest} from "@solady/test/utils/SoladyTest.sol";
import {ERC173, MockERC173} from "./utils/mocks/MockERC173.sol";

/// @dev Adapted from Ownable.t.sol (https://github.com/Vectorized/solady/blob/main/test/Ownable.t.sol)
/// - The only changes are the following as they are not used in Zolidity ERC173:
/// - - Remove initialization tests (`_setOwner` is recycled throughout ERC173)
/// - - Remove Handover tests (no two-step pattern in ERC173 specification)
/// - - Remove direct set owner tests (not included method in Zolidity)
contract ERC173Test is SoladyTest {
    event OwnershipTransferred(address indexed from, address indexed to);

    MockERC173 mockERC173;

    function setUp() public {
        mockERC173 = new MockERC173();
    }

    function testTransferOwnership(
        address newOwner,
        bool setNewOwnerToZeroAddress,
        bool callerIsOwner
    ) public {
        assertEq(mockERC173.owner(), address(this));

        while (newOwner == address(this)) newOwner = _randomNonZeroAddress();

        if (newOwner == address(0) || setNewOwnerToZeroAddress) {
            newOwner = address(0);
            vm.expectEmit(true, true, true, true);
            emit OwnershipTransferred(address(this), _cleaned(newOwner));
        } else if (callerIsOwner) {
            vm.expectEmit(true, true, true, true);
            emit OwnershipTransferred(address(this), _cleaned(newOwner));
        } else {
            vm.prank(newOwner);
            vm.expectRevert(ERC173.Unauthorized.selector);
        }

        mockERC173.transferOwnership(newOwner);

        if (newOwner != address(0) && callerIsOwner) {
            assertEq(mockERC173.owner(), newOwner);
        }
    }

    function testTransferOwnership() public {
        testTransferOwnership(address(1), false, true);
    }

    function testOnlyOwnerModifier(address nonOwner, bool callerIsOwner) public {
        while (nonOwner == address(this)) nonOwner = _randomNonZeroAddress();

        if (!callerIsOwner) {
            vm.prank(nonOwner);
            vm.expectRevert(ERC173.Unauthorized.selector);
        }
        mockERC173.updateFlagWithOnlyOwner();
    }
}
