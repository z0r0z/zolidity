// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice Minimal nonfungible token interface.
/// @author Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/interfaces/IERC721.sol)
/// @dev Boolean is not returned so that this interface works with non-conforming tokens too.
interface IERC721 {
    function approve(address, uint256) external;
    function transferFrom(address, address, uint256) external;
    function safeTransferFrom(address, address, uint256) external;
    function balanceOf(address) external view returns (uint256);
    function ownerOf(uint256) external view returns (address);
}
