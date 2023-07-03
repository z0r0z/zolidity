// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev ERC20 token
/// @author Zolidity
abstract contract ERC20 {
    event Approval(address indexed from, address indexed to, uint256 amt);
    event Transfer(address indexed from, address indexed to, uint256 amt);

    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) public balanceOf;

    uint256 public totalSupply;

    function approve(address to, uint256 amt) external payable returns (bool) {
        allowance[msg.sender][to] = amt;
        emit Approval(msg.sender, to, amt);
        return true;
    }

    function transfer(address to, uint256 amt) external payable returns (bool) {
        balanceOf[msg.sender] -= amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(msg.sender, to, amt);
        return true;
    }

    function transferFrom(address from, address to, uint256 amt) external payable returns (bool) {
        allowance[from][msg.sender] -= amt;
        balanceOf[from] -= amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(from, to, amt);
        return true;
    }

    function _mint(address to, uint256 amt) internal {
        totalSupply += amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(address(0), to, amt);
    }

    function _burn(address from, uint256 amt) internal {
        balanceOf[from] -= amt;
        unchecked {
            totalSupply -= amt;
        }
        emit Transfer(from, address(0), amt);
    }
}
