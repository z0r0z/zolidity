// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @dev Zolidity ERC20 token formatted for fixed-supply deployments.
contract Token {
    event Transfer(address indexed by, address indexed to, uint amt);
    event Approval(address indexed by, address indexed to, uint amt);

    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => uint) public balanceOf;
    uint public constant decimals = 18;
    uint public totalSupply;
    string public symbol;
    string public name;

    constructor(
        string memory $symbol,
        string memory $name,
        address to,
        uint amt
    ) payable {
        emit Transfer(address(0), to, totalSupply = balanceOf[to] = amt);
        symbol = $symbol;
        name = $name;
    }

    function approve(address to, uint amt) public payable returns (bool) {
        emit Approval(msg.sender, to, amt);
        allowance[msg.sender][to] = amt;
        return true;
    }

    function transfer(address to, uint amt) public payable returns (bool) {
        return transferFrom(msg.sender, to, amt);
    }

    function transferFrom(address by, address to, uint amt)
        public
        payable
        returns (bool)
    {
        if (by != msg.sender) allowance[by][msg.sender] -= amt;
        emit Transfer(by, to, amt);
        unchecked {
            balanceOf[to] += amt;
        }
        balanceOf[by] -= amt;
        return true;
    }
}
