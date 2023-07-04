// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import '../../../src/tkn/ERC20.sol';

/// @dev Mock ERC20 contract
contract MockERC20 is ERC20 {
    constructor(bytes32 name, bytes32 symbol) payable ERC20(name, symbol) {}

    function mint(address to, uint amt) external payable {
        _mint(to, amt);
    }

    function burn(address from, uint amt) external payable {
        _burn(from, amt);
    }
}
