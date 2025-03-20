// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice Standard contract ownership (https://eips.ethereum.org/EIPS/eip-173).
/// @author Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/ERC173.sol)
abstract contract ERC173 {
    event OwnershipTransferred(address indexed from, address indexed to);

    error Unauthorized();

    address public owner;

    modifier onlyOwner() virtual {
        require(msg.sender == owner, Unauthorized());
        _;
    }

    constructor(address _owner) {
        emit OwnershipTransferred(address(0), owner = _owner);
    }

    function transferOwnership(address _owner) public payable virtual onlyOwner {
        emit OwnershipTransferred(msg.sender, owner = _owner);
    }
}
