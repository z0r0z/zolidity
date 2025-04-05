// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @notice Standard contract multicall calling multiple methods in a single call.
/// @author Zolidity (https://github.com/z0r0z/zolidity/blob/main/src/Multicall.sol)
abstract contract Multicall {
  function multicall(bytes[] calldata data) public returns (bytes[] memory results) {
      results = new bytes[](data.length);
      for (uint256 i; i != data.length; ++i) {
          (bool success, bytes memory result) = address(this).delegatecall(data[i]);
          if (!success) {
              assembly {
                  revert(add(result, 0x20), mload(result))
              }
          }
          results[i] = result;
      }
  }
}
