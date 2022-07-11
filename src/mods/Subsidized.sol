// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {ReentrancyGuard} from "./ReentrancyGuard.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

/// @notice Gas refunding for smart contracts.
/// @author z0r0z.eth
/// @custom:coauthor saucepoint
/// @dev Gas should be deposited for refunds.
abstract contract Refunded is ReentrancyGuard {
    using SafeTransferLib for address;

    error FEE_MAX();

    uint256 internal constant BASE_FEE = 2572;

    uint256 internal constant MAX_FEE = 40 * 10**9;
    
    /// @notice Modifier that refunds gas cost to callers.
    /// @dev Modified functions should cost more than 21k gas
    ///      to benefit from refund.
    modifier isRefunded virtual {
        // Memo cost at start of call.
        uint256 cost = gasleft();

        // Check and set reentrancy guard.
        setReentrancyGuard();

        // Check malicious refund with high gas price.
        unchecked {
            if (tx.gasprice > block.basefee + MAX_FEE) revert FEE_MAX();
        }

        // Run modified function.
        _;

        // Memo cost at end of call.
        // (BASE_FEE + (cost - gasleft())) * tx.gasprice
        assembly {
            cost := mul(add(BASE_FEE, sub(cost, gas())), gasprice())
        }

        // Refund deposited ETH for `cost`.
        tx.origin.safeTransferETH(cost);

        // Clear reentrancy guard.
        clearReentrancyGuard();
    }
}
