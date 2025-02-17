// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Standard contract ownership.
/// @author Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/ERC173.sol)
abstract contract ERC173 {
    event OwnershipTransferred(address indexed from, address indexed to);

    error Unauthorized();

    address public owner;

    modifier onlyOwner() virtual {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        _;
    }

    function _setOwner(address to) internal virtual {
        emit OwnershipTransferred(msg.sender, owner = to);
    }

    function transferOwnership(address to) public virtual onlyOwner {
        _setOwner(to);
    }
}
