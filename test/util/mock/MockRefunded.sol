// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import '../../../src/util/Refunded.sol';

/// @dev Mock Refunded contract
contract MockRefunded is Refunded {
    uint counter;

    /// @dev Refunded transaction,
    /// where *most* of gas-cost returned to caller (tx.origin)
    function foo() external payable refunded {
        expensive();
    }

    /// @dev Unrefunded transaction, for testing & comparison
    function bar() external payable {
        expensive();
    }

    /// @dev Gas-expensive function
    function expensive() public payable {
        for (uint i; i < 50; i++) {
            counter++;
        }
    }
}
