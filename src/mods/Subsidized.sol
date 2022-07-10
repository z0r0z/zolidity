// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {ReentrancyGuard} from "./ReentrancyGuard.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

error GAS_MAX();

/// @notice Subsidized transactions for smart contracts.
/// @author z0r0z.eth
/// @custom:coauthor saucepoint
abstract contract Subsidized is ReentrancyGuard {
    using SafeTransferLib for address;

    uint256 internal constant FEE_MAX = 40 * 10**9;
    
    uint256 internal constant SUBSIDY_COST = 2572;
    
    /// @notice Function modifier for returning gas costs to the caller.
    /// @dev Modified functions should be more than 21,000 gas units in order
    ///      to materially observe the subsidy.
    modifier subsidized virtual {
        _setReentrancyGuard();

        uint256 start = gasleft();
        
        // Prevents malicious actor burning all the ETH on gas.
        unchecked {
            if (tx.gasprice > block.basefee + FEE_MAX) revert GAS_MAX();
        }

        _;

        unchecked {
            // Return ETH to the caller, based on total gas cost (gas consumed * gas price).
            // Buffer the subsidy +21,200 gas units since caller is consuming 21,000 gas units for a transfer
            // which is not captured in the `gasleft()` calls.
            // Tack on an additional 200 gas units for the arithmetic.
            tx.origin.safeTransferETH((start - gasleft() + SUBSIDY_COST) * tx.gasprice);
        }

        _clearReentrancyGuard();
    }
}
