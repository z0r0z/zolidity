// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev Token receiver logic
/// @author Zolidity
abstract contract Receiver {
    /// -----------------------------------------------------------------------
    /// ERC165 Introspection
    /// -----------------------------------------------------------------------

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return
        // ERC165 interface ID for ERC165
        interfaceId == this.supportsInterface.selector
        // ERC165 Interface ID for ERC721TokenReceiver
        || interfaceId == this.onERC721Received.selector
        // ERC165 Interface ID for ERC1155TokenReceiver
        || interfaceId == 0x4e2312e0;
    }

    /// -----------------------------------------------------------------------
    /// ETH Receiver
    /// -----------------------------------------------------------------------

    receive() external payable virtual {}

    /// -----------------------------------------------------------------------
    /// ERC721 Receiver
    /// -----------------------------------------------------------------------

    function onERC721Received(address, address, uint, bytes calldata)
        public
        payable
        virtual
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

    /// -----------------------------------------------------------------------
    /// ERC1155 Receiver
    /// -----------------------------------------------------------------------

    function onERC1155Received(address, address, uint, uint, bytes calldata)
        public
        payable
        virtual
        returns (bytes4)
    {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint[] calldata,
        uint[] calldata,
        bytes calldata
    ) public payable virtual returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}
