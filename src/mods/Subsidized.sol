// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

// (forge-style import)
// import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

/// @author z0r0z.eth, @saucepoint
abstract contract Subsidized {
    using SafeTransferLib for address;
    
    /// @notice Function modifier for returning gas costs to the caller.
    /// @dev Modified functions should be more than 21,000 gas units in order
    /// to materially observe the subsidy.
    modifier subsidized {
        uint256 startGas = gasleft();
        
        _;
        
        unchecked {
            // Return ETH to the caller, based on total gas cost (gas consumed * gas price).
            // Buffer the subsidy +25,000 gas units since caller is consuming 21,000 gas units for a transfer
            // (which is not captured in the `gasleft()` calls).
            // Tack on an additional 4,000 gas units for the arithmetic
            // - there's a way to make it exact, but I'm lazy.
            tx.origin.safeTransferETH((startGas - gasleft() + 25000) * tx.gasprice);
        }
    }
}
