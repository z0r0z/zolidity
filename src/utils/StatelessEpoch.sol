// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

/// @notice Stateless, self-updating epochs for smart contracts.
/// @author saucepoint
/// @dev Be conscious of abuse by miners which can modify block.timestamp
abstract contract StatelessEpoch {
    /// Look mom, no state!

    /// @dev Override this function in the child contract
    /// The value returned by this view function is the number of seconds between each epoch
    function epochPeriod() public pure virtual returns (uint256) {
        return 0;
    }

    function getEpoch() public view returns (uint256) {
        return block.timestamp % epochPeriod();
    }
}
