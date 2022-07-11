// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {ReentrancyGuard} from "./ReentrancyGuard.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

/// @notice Gas refunds for smart contracts.
/// @author z0r0z.eth
/// @custom:coauthor saucepoint
/// @dev Gas should be deposited for refunds.
abstract contract Refunded is ReentrancyGuard {
    using SafeTransferLib for address;

    /// @dev Emitted if gas price limit exceeded.
    error FEE_MAX();

    /// @dev Gas fee for modifier with padding.
    uint256 internal constant BASE_FEE = 3000;

    /// @dev Reasonable limit for gas price.
    uint256 internal constant MAX_FEE = 4e10; // 4*10**10
    
    /// @notice Modifier that refunds gas fee.
    /// @dev Modified functions costing more than 21k gas
    ///      benefit most from refund.
    modifier isRefunded virtual {
        // Memo `fee` at start of call.
        uint256 fee = gasleft();

        // Check and set reentrancy guard.
        setReentrancyGuard();

        // Check malicious refund against gas price limit.
        unchecked {
            if (tx.gasprice > block.basefee + MAX_FEE) revert FEE_MAX();
        }

        // Run modified function.
        _;

        // Memo `fee` at end of call.
        // (BASE_FEE + (fee - gasleft())) * tx.gasprice
        assembly {
            fee := mul(add(BASE_FEE, sub(fee, gas())), gasprice())
        }

        // Refund deposited gas for `fee`.
        tx.origin.safeTransferETH(fee);

        // Clear reentrancy guard.
        clearReentrancyGuard();
    }
}
