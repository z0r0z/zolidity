// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC173} from "../../../src/ERC173.sol";
import {Brutalizer} from "@solady/test/utils/Brutalizer.sol";

/// @notice Standard test contract ownership.
contract MockERC173 is ERC173(msg.sender), Brutalizer {
    bool public flag;

    constructor() payable {}

    function transferOwnership(address to) public payable virtual override(ERC173) {
        super.transferOwnership(_brutalized(to));
    }

    function updateFlagWithOnlyOwner() public onlyOwner {
        flag = true;
    }
}
