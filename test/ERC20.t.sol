// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import 'forge-std/Test.sol';
import './util/mock/MockERC20.sol';

contract ERC20Test is Test {
    using stdStorage for StdStorage;

    string META = 'META';
    uint constant ethSum = 100 ether;
    address immutable alice = vm.addr(1);

    MockERC20 tkn;

    constructor() payable {}

    function setUp() public payable {
        console.log(unicode'🧪 Testing ERC20...');
        tkn = new MockERC20(META, META);
        tkn.mint(alice, ethSum);
    }

    function testDeploy() public payable {
        new MockERC20(META, META);
    }

    function _safeTransfer(address from, address to, uint amt) internal {
        uint balance = tkn.balanceOf(from);
        amt = balance < amt ? balance : amt;

        if (from != address(tkn)) {
            vm.prank(from);
        }

        tkn.transfer(to, amt);
    }

    function testTransfer(address bob, uint amt) public payable {
        uint alice_balance = tkn.balanceOf(alice);
        if (amt > alice_balance) amt = alice_balance; // only transfer max possible amount

        vm.prank(alice);
        tkn.transfer(bob, amt);

        unchecked {
            assertEq(tkn.balanceOf(alice), alice_balance - amt);
            assertEq(tkn.balanceOf(bob), amt);
        }
    }

    function testApprove(address bob, uint amt) public payable {
        uint aliceBalance = tkn.balanceOf(alice);
        amt = amt > aliceBalance ? aliceBalance : amt;

        vm.prank(alice);
        tkn.approve(bob, amt);

        assertEq(tkn.allowance(alice, bob), amt);
    }

    function testTransferFrom(address bob, uint amt) public payable {
        uint aliceBalance = tkn.balanceOf(alice);
        amt = amt > aliceBalance ? aliceBalance : amt;

        testApprove(bob, amt);

        vm.prank(bob);
        tkn.transferFrom(alice, bob, amt);

        assertEq(tkn.balanceOf(bob), amt);
    }

    function testMint(address bob, uint amt) public payable {
        uint max_mint_value = type(uint).max - ethSum;
        amt = amt > max_mint_value ? max_mint_value : amt;

        tkn.mint(bob, amt);

        assertEq(tkn.totalSupply(), ethSum + amt);
        assertEq(tkn.balanceOf(bob), amt);
    }

    function testBurn(address bob, uint amt) public payable {
        uint max_burn_value = tkn.balanceOf(bob);
        amt = amt > max_burn_value ? max_burn_value : amt;

        vm.prank(bob);
        tkn.burn(bob, amt);

        assertEq(tkn.totalSupply(), ethSum - amt);
        assertEq(tkn.balanceOf(bob), max_burn_value - amt);
    }
}
