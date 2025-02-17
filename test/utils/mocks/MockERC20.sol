// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "../../../src/ERC20.sol";
import {Brutalizer} from "@solady/test/utils/Brutalizer.sol";

/// @notice Standard fungible test token.
contract MockERC20 is ERC20("TEST", "TEST"), Brutalizer {
    function mint(address to, uint256 amount) public virtual {
        _mint(_brutalized(to), amount);
    }

    function burn(address from, uint256 amount) public virtual {
        _burn(_brutalized(from), amount);
    }

    function transfer(address to, uint256 amount) public virtual override(ERC20) returns (bool) {
        return super.transfer(_brutalized(to), amount);
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        virtual
        override(ERC20)
        returns (bool)
    {
        return super.transferFrom(_brutalized(from), _brutalized(to), amount);
    }
}
