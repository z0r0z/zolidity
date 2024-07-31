// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Simple mintable and burnable ERC20 token prefabrication.
/// @author Zolidity (https://github.com/z0r0z/zolidity/tkn/fab/Token.sol)
contract Token {
    event Approval(address indexed from, address indexed to, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);
    event OwnershipTransferred(address indexed from, address indexed to);

    error Unauthorized();

    modifier onlyOwner {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    string public name;
    string public symbol;
    address public owner;
    uint public totalSupply;
    uint public constant decimals = 18;
    
    mapping(address owner => uint) public balanceOf;
    mapping(address owner => mapping(address spender => uint)) public allowance;

    constructor(string memory _name, string memory _symbol, address _owner, uint _supply) payable {
        (name, symbol) = (_name, _symbol);
        balanceOf[owner = _owner] = totalSupply = _supply;
    }

    function approve(address to, uint amount) public returns (bool) {
        allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transfer(address to, uint amount) public returns (bool) {
        return transferFrom(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint amount) public returns (bool) {
        if (msg.sender != from) if (allowance[from][msg.sender] != type(uint).max)
            allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(from, to, amount);
        return true;
    }

    function transferOwnership(address to) public onlyOwner {
        emit OwnershipTransferred(msg.sender, owner = to);
    }

    function mint(address to, uint amount) public onlyOwner {
        totalSupply += amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(address(0), to, amount);
    }

    function burn(uint amount) public {
        balanceOf[msg.sender] -= amount;
        unchecked { totalSupply -= amount; }
        emit Transfer(msg.sender, address(0), amount);
    }
}
