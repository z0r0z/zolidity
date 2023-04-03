// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {ReentrancyGuard} from "./ReentrancyGuard.sol";
import {safeTransferETH} from "./SafeTransfer.sol";

/// @notice Gas refunds for smart contracts.
/// @author z0r0z.eth
/// @custom:coauthor saucepoint
/// @dev Gas should be deposited for refunds.
abstract contract Refunded is ReentrancyGuard {
    error GasMax(address emitter);

    uint256 internal constant BASE_COST = 25433;

    uint256 internal constant GAS_PRICE_MAX = 4e10;

    constructor() payable {}

    receive() external payable virtual {}

    /// @dev Modified functions over 21k gas
    ///      benefit most from refund.
    modifier isRefunded() virtual {
        // Memo starting gas.
        uint256 refund = gasleft();

        setReentrancyGuard();

        // Check malicious refund.
        unchecked {
            if (tx.gasprice > block.basefee + GAS_PRICE_MAX) {
                revert GasMax(address(this));
            }
        }

        _;

        // Memo ending gas.
        // (BASE_COST + (refund - gasleft())) * tx.gasprice
        assembly {
            refund := mul(add(BASE_COST, sub(refund, gas())), gasprice())
        }

        // Refund gas fee.
        safeTransferETH(tx.origin, refund);

        clearReentrancyGuard();
    }
}
