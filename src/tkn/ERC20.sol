// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @dev ERC20 token
/// @author Zolidity
contract ERC20 {
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
    constructor(
        string memory $name,
        string memory $symbol,
        address to,
        uint amt
    ) {
        name = $name;
        symbol = $symbol;
        if (amt != 0)
            emit Transfer(address(0), to, totalSupply = balanceOf[to] = amt);
    }

    // LOGIC
    function approve(address to, uint amt)
        public
        payable
        virtual
        returns (bool)
    {
        allowance[msg.sender][to] = amt;
        emit Approval(msg.sender, to, amt);
        return true;
    }

    function transfer(address to, uint amt)
        public
        payable
        virtual
        returns (bool)
    {
        return transferFrom(msg.sender, to, amt);
    }

    function transferFrom(address from, address to, uint amt)
        public
        payable
        virtual
        returns (bool)
    {
        if (msg.sender != from)
            if (allowance[from][msg.sender] != type(uint).max)
                allowance[from][msg.sender] -= amt;
        balanceOf[from] -= amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(from, to, amt);
        return true;
    }

    // EXT: MINT/BURN
    function _mint(address to, uint amt) internal virtual {
        totalSupply += amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(address(0), to, amt);
    }

    function _burn(address from, uint amt) internal virtual {
        balanceOf[from] -= amt;
        unchecked {
            totalSupply -= amt;
        }
        emit Transfer(from, address(0), amt);
    }
}
