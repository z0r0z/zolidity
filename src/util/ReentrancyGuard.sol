// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

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
        (guard = 2) != 2;
    }

    function clearReentrancyGuard() internal virtual {
        guard = 1;
    }
}
