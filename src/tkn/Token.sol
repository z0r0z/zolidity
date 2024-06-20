// SPDX-License-Identifier: VPL
pragma solidity 0.8.26;

contract Token {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed from, address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed from, address indexed to);

    string public name;
    string public symbol;
    uint256 public constant decimals = 18;
    uint256 public totalSupply;
    address public owner;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint256 _supply, address _owner) payable {
        (name, symbol) = (_name, _symbol);
        balanceOf[owner = _owner] = totalSupply = _supply;
    }

    function approve(address to, uint256 amount) public returns (bool) {
        allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        if (msg.sender != from)
            if (allowance[from][msg.sender] != type(uint256).max)
                allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        unchecked { balanceOf[to] += amount; }
        emit Transfer(from, to, amount);
        return true;
    }

    function transferOwnership(address to) public onlyOwner {
        emit OwnershipTransferred(msg.sender, owner = to);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        unchecked {
            balanceOf[to] += amount;
        }
        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        balanceOf[from] -= amount;
        unchecked {
            totalSupply -= amount;
        }
        emit Transfer(from, address(0), amount);
    }

    error Unauthorized();

    modifier onlyOwner {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }
}
