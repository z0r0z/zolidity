// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "../../../src/tkn/ERC20.sol";

/// @dev Mock ERC20 contract
contract MockERC20 is ERC20 {
    function mint(address to, uint256 amt) external payable {
        _mint(to, amt);
    }
}
