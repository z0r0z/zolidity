// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev ERC20 token
/// @author Zolidity
contract ERC20 {
    /// -----------------------------------------------------------------------
    /// ERC20 events
    /// -----------------------------------------------------------------------

    event Transfer(address indexed from, address indexed to, uint amt);
    event Approval(address indexed from, address indexed to, uint amt);

    /// -----------------------------------------------------------------------
    /// ERC20 storage
    /// -----------------------------------------------------------------------

    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => uint) public balanceOf;

    uint public totalSupply;

    /// -----------------------------------------------------------------------
    /// ERC20 metadata immutables
    /// -----------------------------------------------------------------------

    bytes32 immutable _name;
    bytes32 immutable _symbol;
    uint public constant decimals = 18;

    function name() public view returns (string memory) {
        return string(abi.encodePacked(_name));
    }

    function symbol() public view returns (string memory) {
        return string(abi.encodePacked(_symbol));
    }

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------

    constructor(bytes32 __name, bytes32 __symbol) payable {
        _name = __name;
        _symbol = __symbol;
    }

    /// -----------------------------------------------------------------------
    /// ERC20 logic
    /// -----------------------------------------------------------------------

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

    /// -----------------------------------------------------------------------
    /// Internal mint/burn logic
    /// -----------------------------------------------------------------------

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
