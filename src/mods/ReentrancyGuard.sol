// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

/// @notice Reentrancy protection for smart contracts.
/// @author z0r0z.eth
/// @author Modified from Seaport 
///         (https://github.com/ProjectOpenSea/seaport/blob/main/contracts/lib/ReentrancyGuard.sol)
/// @author Modified from Solmate 
///         (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    /// @dev Throws if contract function is reentered.
    error REENTRANCY();
    
    /// @dev Reentrancy guard value.
    uint256 private locked = 1;

    /// @dev Modifier to ensure reentrancy protection.
    modifier nonReentrant() virtual {
        // Check reentrancy guard is not already set.
        if (locked >= 2) revert REENTRANCY();

        // Set reentrancy guard.
        locked = 2;
        
        // Run modified function.
        _;

        // Clear reentrancy guard.
        locked = 1;
    } 

    /// @dev Ensure that sentinel value for 
    ///      reentrancy guard is not currently set, and, 
    ///      if not, set sentinel value for reentrancy guard.
    function setReentrancyGuard() internal virtual {
        // Check reentrancy guard is not already set.
        if (locked >= 2) revert REENTRANCY();

        // Set reentrancy guard.
        locked = 2;
    }

    /// @dev Unset reentrancy guard sentinel value.
    function clearReentrancyGuard() internal virtual {
        // Clear reentrancy guard.
        locked = 1;
    }
}
