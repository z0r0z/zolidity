// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @dev Token receiver logic
/// @author Zolidity
abstract contract Receiver {
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        returns (bool)
    {
        return interfaceId == this.supportsInterface.selector
            || interfaceId == this.onERC721Received.selector
            || interfaceId
                == this.onERC1155Received.selector
                    ^ this.onERC1155BatchReceived.selector;
    }

    receive() external payable virtual {}

    function onERC721Received(address, address, uint, bytes calldata)
        public
        payable
        virtual
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }

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
