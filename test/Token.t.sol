// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './util/mock/MockERC20.sol';
import 'forge-std/Test.sol';

contract TokenTest is Test {
    MockERC20 immutable tkn = new MockERC20(
        'Test', 'TEST', address(this), bigAmt);
    address immutable tester = address(this);
    address immutable alice = vm.addr(1);
    address immutable bob = vm.addr(2);
    uint constant bigAmt = 100 ether;
    uint constant lilAmt = 10 ether;

    function setUp() public payable {
        console.log(unicode'🧪 Testing ERC20...');
    }

    function testDeploy() public payable {
        new MockERC20('NA', 'NA', address(0), 0);
    }

    function testDeployWithMint() public payable {
        new MockERC20('NA', 'NA', alice, 10_000_000 ether);
    }

    function testFailDeploySupplyOverflow() public payable {
        new MockERC20('NA', 'NA', alice, type(uint).max + 1);
    }

    function testApprove() public payable {
        tkn.approve(bob, lilAmt);
        assertEq(tkn.allowance(tester, bob), lilAmt);
    }

    function testTransfer() public payable {
        tkn.transfer(alice, lilAmt);
        assertEq(tkn.balanceOf(alice), lilAmt);
    }

    function testTransferFrom() public payable {
        tkn.approve(bob, lilAmt);
        vm.prank(bob);
        tkn.transferFrom(tester, bob, lilAmt);
        assertEq(tkn.balanceOf(bob), lilAmt);
    }

    function testFailTransferExceedsBalance() public payable {
        tkn.transfer(alice, bigAmt + 1);
    }

    function testFailTransferFromExceedsBalance() public payable {
        tkn.approve(bob, bigAmt);
        vm.prank(bob);
        tkn.transferFrom(tester, bob, bigAmt + 1);
    }

    function testFailTransferFromExceedsAllowance() public payable {
        tkn.approve(bob, lilAmt);
        vm.prank(bob);
        tkn.transferFrom(tester, bob, lilAmt + 1);
    }
}
