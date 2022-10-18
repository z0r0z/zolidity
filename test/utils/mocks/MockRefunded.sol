// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {Refunded} from "../../../src/utils/Refunded.sol";

/// @notice Mock Refunded contract.
contract MockRefunded is Refunded {
    uint256 private counter;

    /// @dev Refunded transaction,
    /// where *most* of the gas-cost is returned to the caller (tx.origin).
    function foo() public isRefunded {
        expensive();
    }

    /// @dev Unrefunded transaction, for testing & comparison.
    function bar() public {
        expensive();
    }

    /// @dev A gas-expensive function.
    function expensive() public {
        for (uint256 i = 0; i < 50; i++) {
            counter++;
        }
    }
}
