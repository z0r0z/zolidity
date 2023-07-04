// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import 'forge-std/Test.sol';
import './util/mock/MockERC20.sol';

contract ERC20Test is Test {
    using stdStorage for StdStorage;

    MockERC20 immutable tkn = new MockERC20(
        'Test', 'TEST', 0);
    address immutable tester = address(this);
    address immutable alice = vm.addr(1);
    address immutable bob = vm.addr(2);
    uint constant bigAmt = 100 ether;
    uint constant lilAmt = 10 ether;

    function setUp() external payable {
        console.log(unicode'🧪 Testing ERC20...');
        tkn.mint(tester, bigAmt);
    }

    function testDeploy() external payable {
        new MockERC20('NA', 'NA', type(uint).max);
    }

    function testFailDeploySupplyOverflow() external payable {
        new MockERC20('NA', 'NA', type(uint).max + 1);
    }

    function testApprove() external payable {
        tkn.approve(bob, lilAmt);
        assertEq(tkn.allowance(tester, bob), lilAmt);
    }

    function testTransfer() external payable {
        tkn.transfer(alice, lilAmt);
        assertEq(tkn.balanceOf(alice), lilAmt);
    }

    function testTransferFrom() external payable {
        tkn.approve(bob, lilAmt);
        vm.prank(bob);
        tkn.transferFrom(tester, bob, lilAmt);
        assertEq(tkn.balanceOf(bob), lilAmt);
    }

    function testFailTransferExceedsBalance() external payable {
        tkn.transfer(alice, bigAmt + 1);
    }

    function testFailTransferFromExceedsBalance() external payable {
        tkn.approve(bob, bigAmt);
        vm.prank(bob);
        tkn.transferFrom(tester, bob, bigAmt + 1);
    }

    function testFailTransferFromExceedsAllowance() external payable {
        tkn.approve(bob, lilAmt);
        vm.prank(bob);
        tkn.transferFrom(tester, bob, lilAmt + 1);
    }
}
