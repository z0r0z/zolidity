// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice Minimal fungible token interface.
/// @author Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/interfaces/IERC20.sol)
interface IERC20 {
    function approve(address, uint256) external;
    function transfer(address, uint256) external;
    function transferFrom(address, address, uint256) external;
    function balanceOf(address) external view returns (uint256);
}