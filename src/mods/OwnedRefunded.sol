// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {Refunded} from "./Refunded.sol";

/// @notice Gas refunds for smart contract owners.
/// @author z0r0z.eth
abstract contract RefundedOwner is Refunded {
    constructor() payable {}
    
    /// @dev Modified functions over 21k gas
    ///      benefit most from refund.
    modifier isRefundedOwner virtual {
        // Memo starting gas.
        uint256 refund = gasleft();

        setReentrancyGuard();

        // Check malicious refund.
        unchecked {
            if (tx.gasprice > block.basefee + GAS_PRICE_MAX) 
                revert GAS_MAX(address(this));
        }

        _;

        // Memo ending gas.
        // (BASE_COST + (refund - gasleft())) * tx.gasprice
        assembly {
            refund := mul(add(BASE_COST, sub(refund, gas())), gasprice())
        }

        // Refund gas fee to `owner`.
        owner.safeTransferETH(refund);

        clearReentrancyGuard();
    }
}
