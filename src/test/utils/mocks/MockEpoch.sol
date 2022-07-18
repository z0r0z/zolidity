// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {StatelessEpoch} from "../../../utils/StatelessEpoch.sol";

/// @notice An example contract that inherits and utilizes StatelessEpoch
contract MockEpoch is StatelessEpoch {
    // a typical state epoch thats managed by external calls (incrementEpoch())
    uint256 public epoch;

    // a mock state variable in which epoch is utilized
    // maps epoch => counter
    mapping(uint256 => uint256) public epochCounter;


    function useEpoch() public {
        unchecked { epochCounter[epoch]++; }
    }

    function incrementEpoch() public {
        unchecked { epoch++; }
    }

    function useStatelessEpoch() public {
        unchecked { epochCounter[getEpoch()]++; }
    }

    function epochPeriod() public pure override returns (uint256) {
        // monthly epochs (seconds per month)
        // (60 * 60 * 24 * 365) / 12 = 2628000
        return 2628000;
    }
}