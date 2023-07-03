// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "./util/mock/MockERC20.sol";

contract ERC20Test is Test {
    using stdStorage for StdStorage;

    bytes32 constant META = keccak256("META");
    uint256 constant ethSum = 100 ether;

    MockERC20 immutable tkn = new MockERC20(META, META);
    address immutable alice = vm.addr(1);

    constructor() payable {}

    function setUp() public payable {
        console.log(unicode"🧪 Testing ERC20...");
        tkn.mint(alice, ethSum);
    }

    function testDeploy() public payable {
        new MockERC20(META, META);
    }

    function testTransfer(address bob, uint256 amt) public payable {
        vm.assume(bob != alice);
        vm.assume(amt <= ethSum);

        vm.prank(alice);
        tkn.transfer(bob, amt);

        unchecked {
            assertEq(tkn.balanceOf(alice), ethSum - amt);
            assertEq(tkn.balanceOf(bob), amt);
        }
    }

    function testApprove(address bob, uint256 amt) public payable {
        vm.assume(amt <= tkn.balanceOf(alice));
        vm.prank(alice);
        tkn.approve(bob, amt);
        assertEq(tkn.allowance(alice, bob), amt);
    }

    function testTransferFrom(address bob, uint256 amt) public payable {
        vm.assume(amt <= tkn.allowance(alice, bob));
        testApprove(bob, amt);

        vm.prank(bob);
        tkn.transferFrom(alice, bob, amt);
        assertEq(tkn.balanceOf(bob), amt);
    }

    function testMint(address bob, uint256 amt) public payable {
        vm.assume(amt <= type(uint256).max - tkn.totalSupply());
        uint256 initialSupply = tkn.totalSupply();
        tkn.mint(bob, amt);
        assertEq(tkn.totalSupply(), initialSupply + amt);
        assertEq(tkn.balanceOf(bob), amt);
    }

    function testBurn(address bob, uint256 amt) public payable {
        vm.assume(amt <= tkn.totalSupply());
        tkn.mint(bob, amt);
        uint256 initialSupply = tkn.totalSupply();
        vm.prank(bob);
        tkn.burn(bob, amt);
        assertEq(tkn.totalSupply(), initialSupply - amt);
        assertEq(tkn.balanceOf(bob), 0);
    }
}
