// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @notice Safe ETH & ERC20 free functions
/// @author Zolidity

/// @dev Safe ETH transfer
function safeTransferETH(address to, uint amt) {
    assembly {
        if iszero(call(gas(), to, amt, 0, 0, 0, 0)) {
            mstore(0x00, 0xb12d13eb)
            revert(0x1c, 0x04)
        }
    }
}

/// @dev Safe ERC20 approve
function safeApprove(address tkn, address to, uint amt) {
    assembly {
        let memPointer := mload(0x40)

        mstore(0x00, 0x095ea7b3)
        mstore(0x20, to)
        mstore(0x40, amt)

        if iszero(
            and(
                or(eq(mload(0x00), 1), iszero(returndatasize())),
                call(gas(), tkn, 0, 0x1c, 0x44, 0x00, 0x20)
            )
        ) {
            mstore(0x00, 0x3e3f8f73)
            revert(0x1c, 0x04)
        }

        mstore(0x40, memPointer)
    }
}

/// @dev Safe ERC20 transfer
function safeTransfer(address tkn, address to, uint amt) {
    assembly {
        let memPointer := mload(0x40)

        mstore(0x00, 0xa9059cbb)
        mstore(0x20, to)
        mstore(0x40, amt)

        if iszero(
            and(
                or(eq(mload(0x00), 1), iszero(returndatasize())),
                call(gas(), tkn, 0, 0x1c, 0x44, 0x00, 0x20)
            )
        ) {
            mstore(0x00, 0x90b8ec18)
            revert(0x1c, 0x04)
        }

        mstore(0x40, memPointer)
    }
}

/// @dev Safe ERC20 transferFrom
function safeTransferFrom(address tkn, address from, address to, uint amt) {
    assembly {
        let memPointer := mload(0x40)

        mstore(0x00, 0x23b872dd)
        mstore(0x20, from)
        mstore(0x40, to)
        mstore(0x60, amt)

        if iszero(
            and(
                or(eq(mload(0x00), 1), iszero(returndatasize())),
                call(gas(), tkn, 0, 0x1c, 0x64, 0x00, 0x20)
            )
        ) {
            mstore(0x00, 0x7939f424)
            revert(0x1c, 0x04)
        }

        mstore(0x60, 0)
        mstore(0x40, memPointer)
    }
}
