// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @dev Reentrancy guard logic
/// @author Zolidity
abstract contract ReentrancyGuard {
    uint guard = 1;

    modifier nonReentrant() virtual {
        setReentrancyGuard();
        _;
        clearReentrancyGuard();
    }

    function setReentrancyGuard() internal virtual {
        guard = guard == 2 ? (guard - 3) : 2;
    }

    function clearReentrancyGuard() internal virtual {
        guard = 1;
    }
}
