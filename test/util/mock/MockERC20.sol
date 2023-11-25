// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import '../../../src/tkn/Token.sol';

/// @dev Mock ERC20 contract
contract MockERC20 is Token {
    constructor(
        string memory name,
        string memory symbol,
        address to,
        uint amt
    ) payable Token(name, symbol, to, amt) {}
}
