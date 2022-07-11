// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {Refunded} from "../../../mods/Subsidized.sol";

contract MockRefunded is Refunded {
    uint256 counter;

    receive() external payable {}

    // Refunded transaction, where *most* of the gas-cost is returned to the caller (tx.origin).
    function foo() public isRefunded {
        expensive();
    }

    // Unrefunded transaction, for testing & comparison.
    function bar() public {
        expensive();
    }

    // A gas-expensive function.
    function expensive() public {
        for (uint256 i=0; i < 50; i++){
            counter++;
        }
    }
}
