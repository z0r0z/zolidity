// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @dev ERC721 token
/// @author Zolidity
abstract contract ERC721 {
    event Transfer(
        address indexed from, address indexed to, uint indexed id
    );
    event Approval(
        address indexed from, address indexed to, uint indexed id
    );
    event ApprovalForAll(
        address indexed from, address indexed to, bool yepp
    );

    // STORAGE
    mapping(address from => uint) public balanceOf;
    mapping(uint id => address) public ownerOf;
    mapping(uint id => address) public getApproved;
    mapping(address from => mapping(address to => bool)) public
        isApprovedForAll;

    // METADATA
    string public name;
    string public symbol;

    function tokenURI(uint) public view virtual returns (string memory);

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        returns (bool)
    {
        return interfaceId == this.supportsInterface.selector
            || interfaceId == 0x80ac58cd // ERC721
            || interfaceId == 0x5b5e139f; // ERC721Metadata
    }

    // CREATION
    constructor(string memory $name, string memory $symbol) {
        name = $name;
        symbol = $symbol;
    }

    // LOGIC
    function approve(address to, uint id) public payable virtual {
        if (msg.sender != ownerOf[id]) {
            if (!isApprovedForAll[ownerOf[id]][msg.sender]) {
                revert();
            }
        }

        emit Approval(msg.sender, getApproved[id] = to, id);
    }

    function transferFrom(address from, address to, uint id)
        public
        payable
        virtual
    {
        if (from != ownerOf[id]) {
            revert();
        } else if (msg.sender != from) {
            if (!isApprovedForAll[from][msg.sender]) {
                if (msg.sender != getApproved[id]) {
                    revert();
                }
            }
        }
        unchecked {
            --balanceOf[from];
            ++balanceOf[to];
        }
        ownerOf[id] = to;
        delete getApproved[id];
        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint id)
        public
        payable
        virtual
    {
        transferFrom(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint id,
        bytes calldata
    ) public payable virtual {
        transferFrom(from, to, id);
    }

    // EXT: MINT/BURN
    function _mint(address to, uint id) internal virtual {
        if (ownerOf[id] > address(0)) revert();
        unchecked {
            ++balanceOf[ownerOf[id] = to];
        }
        emit Transfer(address(0), to, id);
    }

    function _burn(uint id) internal virtual {
        address owner = ownerOf[id];
        --balanceOf[owner];
        delete ownerOf[id];
        delete getApproved[id];
        emit Transfer(owner, address(0), id);
    }
}

/// @dev ERC721 receiver
/// @author Zolidity
abstract contract ERC721TokenReceiver {
    function onERC721Received(address, address, uint, bytes calldata)
        public
        payable
        virtual
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }
}
