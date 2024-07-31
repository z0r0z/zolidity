// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Simple mintable and burnable ERC20 token abstraction.
/// @author Zolidity (https://github.com/z0r0z/zolidity/tkn/ERC20.sol)
abstract contract ERC20 {
    event Approval(address indexed from, address indexed to, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

    string public name;
    string public symbol;
    uint public totalSupply;
    uint public constant decimals = 18;
    
    mapping(address owner => uint) public balanceOf;
    mapping(address owner => mapping(address spender => uint)) public allowance;

    constructor(string memory $name, string memory $symbol) payable {
        (name, symbol) = ($name, $symbol);
    }

    function approve(address to, uint amount) public virtual returns (bool) {
        allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transfer(address to, uint amount) public virtual returns (bool) {
        return transferFrom(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint amount) public virtual returns (bool) {
        if (msg.sender != from) if (allowance[from][msg.sender] != type(uint).max)
            allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(from, to, amount);
        return true;
    }

    function _mint(address to, uint amount) internal virtual {
        totalSupply += amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint amount) internal virtual {
        balanceOf[from] -= amount;
        unchecked { totalSupply -= amount; }
        emit Transfer(from, address(0), amount);
    }
}