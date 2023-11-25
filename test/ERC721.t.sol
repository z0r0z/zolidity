// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import 'forge-std/Test.sol';
import './util/mock/MockERC721.sol';

contract ERC721Test is Test {
    using stdStorage for StdStorage;

    MockERC721 immutable nft = new MockERC721('Test', 'TEST');
    address immutable tester = address(this);
    address immutable alice = vm.addr(1);
    address immutable bob = vm.addr(2);
    uint constant testTokenId = 100;

    function setUp() public payable {
        console.log(unicode'🧪 Testing ERC721...');
        nft.mint(tester, testTokenId);
    }

    function testDeploy() public payable {
        new MockERC721('NA', 'NA');
    }

    function testApprove() public payable {
        nft.approve(bob, testTokenId);
        assertEq(nft.getApproved(testTokenId), bob);
    }

    function testTransferFrom() public payable {
        nft.transferFrom(tester, alice, testTokenId);
        assertEq(nft.ownerOf(testTokenId), alice);
    }

    function testSafeTransferFrom() public payable {
        nft.mint(tester, testTokenId + 1);
        nft.safeTransferFrom(tester, alice, testTokenId + 1);
        assertEq(nft.ownerOf(testTokenId + 1), alice);
    }

    function testFailTransferExceedsOwnership() public payable {
        nft.mint(tester, testTokenId + 2);
        nft.safeTransferFrom(tester, bob, testTokenId + 3); // tester does not own token 103
    }

    function testFailTransferFromWithoutApproval() public payable {
        nft.mint(tester, testTokenId + 3);
        vm.prank(bob);
        nft.transferFrom(tester, bob, testTokenId + 3); // bob has no approval to transfer
    }

    function testBurn() public payable {
        nft.mint(tester, testTokenId + 4);
        nft.burn(testTokenId + 4);
        assertEq(nft.ownerOf(testTokenId + 4), address(0));
    }
}
