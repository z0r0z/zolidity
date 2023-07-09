// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @dev Reentrancy guard logic
/// @author Zolidity
abstract contract ReentrancyGuard {
    uint guard = 1;

    modifier nonReentrant() {
        setReentrancyGuard();
        _;
        clearReentrancyGuard();
    }

    function setReentrancyGuard() internal {
        guard = guard == 2 ? (guard - 3) : 2;
    }

    function clearReentrancyGuard() internal {
        guard = 1;
    }
}
