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

    /** 
     * @dev Emitted if gas price over limit.
     * @param emitter The contract that emits the error.
     */
    error FEE_MAX(address emitter);

    /// @dev Gas fee for modifier.
    uint256 internal constant BASE_FEE = 25433;

    /// @dev Reasonable limit for gas price.
    uint256 internal constant MAX_FEE = 4e10; // 4*10**10

    /**
     * @dev You can cut out 10 opcodes in the creation-time EVM bytecode
     * if you declare a constructor `payable`.
     *
     * For more in-depth information see here:
     * https://forum.openzeppelin.com/t/a-collection-of-gas-optimisation-tricks/19966/5
     */
    constructor() payable {}

    receive() external payable virtual {}
    
    /// @notice Modifier to refund gas fee.
    /// @dev Modified functions over 21k gas
    ///      benefit most from refund.
    modifier isRefunded virtual {
        // Memo `fee` at start of call.
        uint256 fee = gasleft();

        // Check and set reentrancy guard.
        setReentrancyGuard();

        // Check malicious refund against gas price limit.
        unchecked {
            if (tx.gasprice > block.basefee + MAX_FEE) revert FEE_MAX(address(this));
        }

        // Run modified function.
        _;

        // Memo `fee` at end of call.
        // ~~ (BASE_FEE + (fee - gasleft())) * tx.gasprice
        assembly {
            fee := mul(add(BASE_FEE, sub(fee, gas())), gasprice())
        }

        // Refund deposited gas for `fee`.
        tx.origin.safeTransferETH(fee);

        // Clear reentrancy guard.
        clearReentrancyGuard();
    }
}
