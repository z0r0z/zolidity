// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import '../../../src/tkn/ERC20.sol';

/// @dev Mock ERC20 contract
contract MockERC20 is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        address to,
        uint amt
    ) payable ERC20(name, symbol, to, amt) {}

    function mint(address to, uint amt) public payable {
        _mint(to, amt);
    }

    function burn(address from, uint amt) public payable {
        _burn(from, amt);
    }
}
