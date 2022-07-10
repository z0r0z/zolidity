// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

/// @notice Subsidized transactions for smart contracts.
/// @author z0r0z.eth, @saucepoint
abstract contract Subsidized {
    using SafeTransferLib for address;
    
    /// @notice Function modifier for returning gas costs to the caller.
    /// @dev Modified functions should be more than 21,000 gas units in order
    /// to materially observe the subsidy.
    modifier subsidized virtual {
        uint256 startGas = gasleft();
        
        _;

        unchecked {
            // Return ETH to the caller, based on total gas cost (gas consumed * gas price).
            // Buffer the subsidy +21,200 gas units since caller is consuming 21,000 gas units for a transfer
            // (which is not captured in the `gasleft()` calls).
            // Tack on an additional 200 gas units for the arithmetic
            tx.origin.safeTransferETH((startGas - gasleft() + 21200) * tx.gasprice);
        }
    }
}
