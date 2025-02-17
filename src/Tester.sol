// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

contract Tester {
    event Tested(string _data);

    string public data;

    function test(string calldata _data) public payable {
        emit Tested(data = _data);
    }
}
