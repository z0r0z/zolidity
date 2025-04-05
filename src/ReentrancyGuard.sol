// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice Reentrant call guard.
/// @author SocksNFlops + Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/ReentrancyGuard.sol)
abstract contract ReentrancyGuard {
    bytes32 private constant REENTRANCY_LOCK_SLOT = keccak256("zolidity.reentrancy.lock");

    error Reentrancy();

    modifier nonReentrant() virtual {
        bytes32 slot = REENTRANCY_LOCK_SLOT;
        bytes32 errorSelector = Reentrancy.selector;
        // Check if the lock is set. Revert if it is, otherwise set the lock.
        assembly {
            // Load the transient storage value
            if tload(slot) {
                // If already locked, revert
                mstore(0x00, errorSelector)
                revert(0x00, 0x04)
            }
            // Set lock
            tstore(slot, 1)
        }
        _;
        // Clear the lock
        assembly {
            tstore(slot, 0)
        }
    }
}
