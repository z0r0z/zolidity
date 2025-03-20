// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice Reentrant call guard.
/// @author Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    error Reentrancy();

    uint256 internal _guard = 1;

    modifier nonReentrant() virtual {
        _setReentrancyGuard();
        _;
        _clearReentrancyGuard();
    }

    function _setReentrancyGuard() internal virtual {
        require(_guard == 1, Reentrancy());
        _guard = 2;
    }

    function _clearReentrancyGuard() internal virtual {
        _guard = 1;
    }
}
