// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {StatelessEpoch} from "../../../utils/StatelessEpoch.sol";

// TESTNET DEPLOYMENT: https://rinkeby.etherscan.io/address/0x1fabebc948c313894cd46b277dceb1319440e021
// useStatelessEpoch()  26,399 gas
// useEpoch()           28,433 gas

/// @notice An example contract that inherits and utilizes StatelessEpoch
contract MockEpoch is StatelessEpoch {
    // a typical state epoch thats managed by external calls (incrementEpoch())
    uint256 public epoch;

    // a mock state variable in which epoch is utilized
    // maps epoch => counter
    mapping(uint256 => uint256) public epochCounter;

    // Override the epochPeriod which is required when inheriting from StatelessEpoch
    function epochPeriod() public pure override returns (uint256) {
        // monthly epochs (seconds per month)
        // (60 * 60 * 24 * 365) / 12 = 2628000
        return 2628000;
    }

    // example usage of a state epoch
    function useEpoch() public {
        unchecked { epochCounter[epoch]++; }
    }

    // example usage of manually incrementing an epoch
    function incrementEpoch() public {
        unchecked { epoch++; }
    }

    // example usage of a stateless epoch
    function useStatelessEpoch() public {
        unchecked { epochCounter[getEpoch()]++; }
    }
}