// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import '../../../src/tkn/ERC721.sol';

/// @dev Mock ERC721 contract
contract MockERC721 is ERC721 {
    constructor(string memory name, string memory symbol)
        payable
        ERC721(name, symbol)
    {}

    function mint(address to, uint id) public payable {
        _mint(to, id);
    }

    function burn(uint id) public payable {
        _burn(id);
    }

    function tokenURI(uint) public view override returns (string memory) {}
}
