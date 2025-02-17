// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC173} from "../../../src/ERC173.sol";
import {Brutalizer} from "@solady/test/utils/Brutalizer.sol";

/// @notice Standard test contract ownership.
contract MockERC173 is ERC173, Brutalizer {
    bool public flag;

    constructor() payable {
        _setOwner(msg.sender);
    }

    function setOwnerDirect(address to) public {
        _setOwner(_brutalized(to));
    }

    function transferOwnership(address to) public virtual override(ERC173) {
        super.transferOwnership(_brutalized(to));
    }

    function updateFlagWithOnlyOwner() public onlyOwner {
        flag = true;
    }
}
