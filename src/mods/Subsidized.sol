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

<<<<<<< HEAD
    /// @dev Emitted if gas price limit exceeded.
    error FEE_MAX();

    /// @dev Gas fee for modifier with padding.
    uint256 internal constant BASE_FEE = 3000;

    /// @dev Reasonable limit for gas price.
    uint256 internal constant MAX_FEE = 4e10; // 4*10**10
    
    /// @notice Modifier that refunds gas fee.
    /// @dev Modified functions should cost more than 21k gas
    ///      to benefit from refund.
    modifier isRefunded virtual {
        // Memo `fee` at start of call.
        uint256 fee = gasleft();
=======
    error FEE_MAX();

    uint256 internal constant BASE_FEE = 2572;

    uint256 internal constant MAX_FEE = 40 * 10**9;
    
    /// @notice Modifier that refunds gas cost to callers.
    /// @dev Modified functions should cost more than 21k gas
    ///      to benefit from refund.
    modifier isRefunded virtual {
        // Memo cost at start of call.
        uint256 cost = gasleft();
>>>>>>> 25a7f406b79707289fb962a18e0d9b683eb62e52

        // Check and set reentrancy guard.
        setReentrancyGuard();

<<<<<<< HEAD
        // Check malicious refund against gas price limit.
=======
        // Check malicious refund with high gas price.
>>>>>>> 25a7f406b79707289fb962a18e0d9b683eb62e52
        unchecked {
            if (tx.gasprice > block.basefee + MAX_FEE) revert FEE_MAX();
        }

        // Run modified function.
        _;

<<<<<<< HEAD
        // Memo `fee` at end of call.
        // (BASE_FEE + (fee - gasleft())) * tx.gasprice
        assembly {
            fee := mul(add(BASE_FEE, sub(fee, gas())), gasprice())
        }

        // Refund deposited ETH for `fee`.
        tx.origin.safeTransferETH(fee);
=======
        // Memo cost at end of call.
        // (BASE_FEE + (cost - gasleft())) * tx.gasprice
        assembly {
            cost := mul(add(BASE_FEE, sub(cost, gas())), gasprice())
        }

        // Refund deposited ETH for `cost`.
        tx.origin.safeTransferETH(cost);
>>>>>>> 25a7f406b79707289fb962a18e0d9b683eb62e52

        // Clear reentrancy guard.
        clearReentrancyGuard();
    }
}
