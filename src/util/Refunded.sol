// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import './ReentrancyGuard.sol';
import {safeTransferETH} from './SafeTransfer.sol';

/// @dev Gas refund logic
/// @author Zolidity
abstract contract Refunded is ReentrancyGuard {
    error GasMax(address caller);

    uint constant BASE_COST = 25433;
    uint constant GAS_PRICE_MAX = 4e10;

    receive() external payable virtual {}

    /// @dev Modified functions over 21k gas
    ///      benefit most from refund
    modifier refunded() virtual {
        uint refund = gasleft();
        setReentrancyGuard();
        // Check malicious refund
        unchecked {
            if (tx.gasprice > block.basefee + GAS_PRICE_MAX) {
                revert GasMax(address(this));
            }
        }
        _;
        // Memo spent gas
        unchecked {
            refund = (BASE_COST + (refund - gasleft())) * tx.gasprice;
        }
        // Refund gas fee
        safeTransferETH(tx.origin, refund);
        clearReentrancyGuard();
    }
}
