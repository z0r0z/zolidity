/// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.15 <0.9.0;
import "ds-test/test.sol";
import "./Subsidized.sol";

contract Hevm {
    function warp(uint256) public;
}

contract SubsidizedFactory {

function build() public returns (address out) {
      assembly {
        mstore(mload(0x40), 0x6b5a60020160005260206000f360005260206014f3)
        out := create(0, add(11, mload(0x40)), 21)
      }
   }
}


contract Target {
    function text() public pure returns (bytes32) {
        return bytes32("Hello");
    }
    function val() public payable returns (uint256) {
        return msg.value;
    }
}

contract Test is DSTest {
    Hevm hevm;
    address target;
    address subsidized;
    function setUp() public {
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        target = address(new Target());
        SubsidizedFactory subsidizedFactory = new SubsidizedFactory();
        subsidizedFactory = subsidizedFactory.build();
    }

        
    // returns the 1st 32 bytes of some dynamic data
    function b32(bytes memory data) public pure returns (bytes32 out) {
        assembly {
            out := mload(add(data, 32))
        }
    }

    // parses the 1st word of some dynamic data as a uint256
    function num(bytes memory data) public pure returns (uint256 out) {
        assembly {
            data32 := mload(add(data, 32))
            out := mload(add(data, 32))
        }
    }
}
