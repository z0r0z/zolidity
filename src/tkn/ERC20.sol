// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

/// @dev ERC20 token
/// @author Zolidity
abstract contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amt);

    mapping(address from => mapping(address to => uint256)) public allowance;
    mapping(address to => uint256) public balanceOf;

    uint256 public totalSupply;

    function approve(address to, uint256 amt) external payable returns (bool) {}

    function transfer(address to, uint256 amt) external payable returns (bool) {
        balanceOf[msg.sender] -= amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(msg.sender, to, amt);
        return true;
    }

    function _mint(address to, uint256 amt) internal {
        totalSupply += amt;
        unchecked {
            balanceOf[to] += amt;
        }
        emit Transfer(address(0), to, amt);
    }
}
