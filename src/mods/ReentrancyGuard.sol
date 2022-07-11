// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

/// @notice Reentrancy protection for smart contracts.
/// @author z0r0z.eth
/// @author Modified from Seaport 
///         (https://github.com/ProjectOpenSea/seaport/blob/main/contracts/lib/ReentrancyGuard.sol)
/// @author Modified from Solmate 
///         (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    /// @dev Throws if function is reentered.
    error REENTRANCY();
    
    /// @dev Reentrancy guard value.
    uint256 private guard = 1;

    /// @dev Modifier to ensure reentrancy protection.
    modifier nonReentrant() virtual {
        // Check guard is not already set.
        if (guard >= 2) revert REENTRANCY();

        // Set guard.
        guard = 2;
        
        // Run modified function.
        _;

        // Clear guard.
        guard = 1;
    } 

    /// @dev Ensure that sentinel value for 
    ///      guard is not set, and, if not,
    ///      set sentinel value.
    function setReentrancyGuard() internal virtual {
        // Check guard is not already set.
        if (guard >= 2) revert REENTRANCY();

        // Set guard.
        guard = 2;
    }

    /// @dev Unset guard sentinel value.
    function clearReentrancyGuard() internal virtual {
        // Clear guard.
        guard = 1;
    }
}
