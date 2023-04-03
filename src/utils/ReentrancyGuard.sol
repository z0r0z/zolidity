// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @notice Reentrancy protection for smart contracts.
/// @author z0r0z.eth
/// @author Modified from Seaport
///         (https://github.com/ProjectOpenSea/seaport/blob/main/contracts/lib/ReentrancyGuard.sol)
/// @author Modified from Solmate
///         (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    error Reentrancy();

    uint256 private guard = 1;

    modifier nonReentrant() virtual {
        setReentrancyGuard();

        _;

        clearReentrancyGuard();
    }

    /// @dev Check guard sentinel value and set it.
    function setReentrancyGuard() internal virtual {
        if (guard == 2) {
            revert Reentrancy();
        }

        guard = 2;
    }

    /// @dev Unset sentinel value.
    function clearReentrancyGuard() internal virtual {
        guard = 1;
    }
}
