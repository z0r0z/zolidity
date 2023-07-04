// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev ERC20 token
/// @author Zolidity
abstract contract ERC20 {
    // Initialization
    constructor(bytes32 meta) {
        _meta = meta;
    }

    // ERC20 Events
    event Transfer(address indexed from, address indexed to, uint amt);
    event Approval(address indexed from, address indexed to, uint amt);

    // ERC20 Storage
    mapping(address usr => mapping(address to => uint)) public allowance;
    mapping(address usr => uint) public balanceOf;
    uint public totalSupply;

    // ERC20 Metadata
    uint public constant decimals = 18;
    bytes32 immutable _meta;

    function name() public view returns (string memory) {
        return _clean(bytes16(_meta >> 128));
    }

    function symbol() public view returns (string memory) {
        return _clean(bytes16(_meta));
    }

    function _clean(bytes16 _bytes) private pure returns (string memory) {
        uint8 i = 15;
        while (i != 0 && _bytes[i] == '') --i;
        bytes memory result = new bytes(i + 1);
        for (uint8 j; j <= i; ++j) {
            result[j] = _bytes[j];
        }
        return string(result);
    }

    // ERC20 Logic
    function approve(address to, uint amt) public payable returns (bool) {
        allowance[msg.sender][to] = amt;
        emit Approval(msg.sender, to, amt);
        return true;
    }

    function transfer(address to, uint amt) public payable returns (bool) {
        balanceOf[msg.sender] -= amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(msg.sender, to, amt);
        return true;
    }

    function transferFrom(address from, address to, uint amt) public payable returns (bool) {
        allowance[from][msg.sender] -= amt;
        balanceOf[from] -= amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(from, to, amt);
        return true;
    }

    // Mint & Burn
    function _mint(address to, uint amt) internal {
        totalSupply += amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(address(0), to, amt);
    }

    function _burn(address from, uint amt) internal {
        balanceOf[from] -= amt;
        unchecked {
            totalSupply -= amt;
        }
        emit Transfer(from, address(0), amt);
    }
}
