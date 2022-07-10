// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

error Reentrancy();

/// @notice Reentrancy protection for smart contracts.
/// @author z0r0z.eth
/// @author Modified from Seaport 
///         (https://github.com/ProjectOpenSea/seaport/blob/main/contracts/lib/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    uint256 private locked = 1;

    /// @dev Internal function to ensure that the sentinel value for the
    ///      reentrancy guard is not currently set and, if not, to set the
    ///      sentinel value for the reentrancy guard.
    function _setReentrancyGuard() internal virtual {
        // Ensure that the reentrancy guard is not already set.
        if (locked >= 2) revert Reentrancy();

        // Set the reentrancy guard.
        locked = 2;
    }

    /// @dev Internal function to unset the reentrancy guard sentinel value.
    function _clearReentrancyGuard() internal virtual {
        // Clear the reentrancy guard.
        locked = 1;
    }
}
