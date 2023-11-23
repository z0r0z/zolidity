// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @dev ERC721 token
/// @author Zolidity
abstract contract ERC721 {
    event Transfer(address indexed by, address indexed to, uint indexed id);
    event Approval(address indexed by, address indexed to, uint indexed id);
    event ApprovalForAll(address indexed by, address indexed to, bool ok);

    // STORAGE
    mapping(uint id => address) public ownerOf;
    mapping(address usr => uint) public balanceOf;
    mapping(uint id => address) public getApproved;
    mapping(address usr => mapping(address mgmt => bool)) public
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

    function transferFrom(address by, address to, uint id)
        public
        payable
        virtual
    {
        if (by != ownerOf[id]) {
            revert();
        } else if (msg.sender != by) {
            if (!isApprovedForAll[by][msg.sender]) {
                if (msg.sender != getApproved[id]) {
                    revert();
                }
            }
        }
        unchecked {
            --balanceOf[by];
            ++balanceOf[to];
        }
        ownerOf[id] = to;
        delete getApproved[id];
        emit Transfer(by, to, id);
    }

    function safeTransferFrom(address by, address to, uint id)
        public
        payable
        virtual
    {
        transferFrom(by, to, id);
    }

    function safeTransferFrom(
        address by,
        address to,
        uint id,
        bytes calldata
    ) public payable virtual {
        transferFrom(by, to, id);
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
