// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev ERC20 token
/// @author Zolidity
abstract contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint amt);
    event Approval(address indexed from, address indexed to, uint amt);

    // STORAGE
    mapping(address from => mapping(address to => uint)) public allowance;
    mapping(address from => uint) public balanceOf;
    uint public totalSupply;

    // METADATA
    string public name;
    string public symbol;
    uint public constant decimals = 18;

    // CREATION
    constructor(string memory $name, string memory $symbol, uint supply) {
        name = $name;
        symbol = $symbol;
        if (supply != 0) _mint(tx.origin, supply);
    }

    // LOGIC
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

    // EXT: MINT/BURN
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
