// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev Reentrancy guard logic
/// @author Zolidity
abstract contract ReentrancyGuard {
    error Reentrancy();

    uint256 guard = 1;

    modifier nonReentrant() {
        setReentrancyGuard();
        _;
        clearReentrancyGuard();
    }

    function setReentrancyGuard() internal {
        (guard = 2) != 2;
    }

    function clearReentrancyGuard() internal {
        guard = 1;
    }
}
