// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import 'forge-std/Test.sol';
import '../src/util/ReentrancyGuard.sol';

contract RiskyContract is ReentrancyGuard {
    uint public enterTimes;

    function unprotectedCall() public payable {
        enterTimes++;

        if (enterTimes > 1) return;

        this.protectedCall();
    }

    function protectedCall() public payable nonReentrant {
        enterTimes++;

        if (enterTimes > 1) return;

        this.protectedCall();
    }

    function overprotectedCall() public payable nonReentrant {}
}

contract ReentrancyGuardTest is Test {
    RiskyContract immutable riskyContract = new RiskyContract();

    function invariantReentrancyStatusAlways1() public payable {
        assertEq(uint(vm.load(address(riskyContract), 0)), 1);
    }

    function testFailUnprotectedCall() public payable {
        riskyContract.unprotectedCall();

        assertEq(riskyContract.enterTimes(), 1);
    }

    function testProtectedCall() public payable {
        try riskyContract.protectedCall() {
            fail('Reentrancy Guard Failed To Stop Attacker');
        } catch {}
    }

    function testNoReentrancy() public payable {
        riskyContract.overprotectedCall();
    }
}
