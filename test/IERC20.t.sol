// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {IERC20} from "../src/interfaces/IERC20.sol";

import {Test} from "forge-std/Test.sol";

// Standard ERC20 that returns booleans (compliant)
contract StandardMockERC20 {
    string public name = "Standard Mock Token";
    string public symbol = "SMT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    // Returns boolean as per standard
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // Returns boolean as per standard
    function transfer(address to, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // Returns boolean as per standard
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(_balances[from] >= amount, "Insufficient balance");
        require(_allowances[from][msg.sender] >= amount, "Insufficient allowance");

        if (_allowances[from][msg.sender] != type(uint256).max) {
            _allowances[from][msg.sender] -= amount;
        }

        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    // Test helper function
    function mint(address to, uint256 amount) external {
        _balances[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }
}

// Non-standard ERC20 that doesn't return booleans (like USDT)
contract NonStandardMockERC20 {
    string public name = "Non-Standard Mock Token";
    string public symbol = "NST";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    // Does NOT return boolean (like USDT)
    function approve(address spender, uint256 amount) external {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    // Does NOT return boolean (like USDT)
    function transfer(address to, uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    // Does NOT return boolean (like USDT)
    function transferFrom(address from, address to, uint256 amount) external {
        require(_balances[from] >= amount, "Insufficient balance");
        require(_allowances[from][msg.sender] >= amount, "Insufficient allowance");

        if (_allowances[from][msg.sender] != type(uint256).max) {
            _allowances[from][msg.sender] -= amount;
        }

        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    // Test helper function
    function mint(address to, uint256 amount) external {
        _balances[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }
}

contract LeanIERC20Test is Test {
    StandardMockERC20 standardToken;
    NonStandardMockERC20 nonStandardToken;

    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        standardToken = new StandardMockERC20();
        nonStandardToken = new NonStandardMockERC20();

        // Fund accounts
        standardToken.mint(alice, 1000 ether);
        nonStandardToken.mint(alice, 1000 ether);

        // Label for better trace output
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
    }

    function testStandardTokenTransfer() public {
        // We need to prank as Alice since she has the tokens
        vm.startPrank(alice);

        // Transfer using the interface
        IERC20(address(standardToken)).transfer(bob, 100 ether);

        // Verify balances
        assertEq(standardToken.balanceOf(bob), 100 ether);
        assertEq(standardToken.balanceOf(alice), 900 ether);

        vm.stopPrank();
    }

    function testNonStandardTokenTransfer() public {
        // We need to prank as Alice since she has the tokens
        vm.startPrank(alice);

        // Transfer using the interface
        IERC20(address(nonStandardToken)).transfer(bob, 100 ether);

        // Verify balances
        assertEq(nonStandardToken.balanceOf(bob), 100 ether);
        assertEq(nonStandardToken.balanceOf(alice), 900 ether);

        vm.stopPrank();
    }

    function testStandardTokenApproveAndTransferFrom() public {
        // Alice approves this contract to spend her tokens
        vm.startPrank(alice);
        IERC20(address(standardToken)).approve(address(this), 500 ether);
        vm.stopPrank();

        // Verify approval
        assertEq(standardToken.allowance(alice, address(this)), 500 ether);

        // Use transferFrom as this contract
        IERC20(address(standardToken)).transferFrom(alice, bob, 300 ether);

        // Verify balances
        assertEq(standardToken.balanceOf(alice), 700 ether);
        assertEq(standardToken.balanceOf(bob), 300 ether);

        // Verify allowance was reduced
        assertEq(standardToken.allowance(alice, address(this)), 200 ether);
    }

    function testNonStandardTokenApproveAndTransferFrom() public {
        // Alice approves this contract to spend her tokens
        vm.startPrank(alice);
        IERC20(address(nonStandardToken)).approve(address(this), 500 ether);
        vm.stopPrank();

        // Verify approval
        assertEq(nonStandardToken.allowance(alice, address(this)), 500 ether);

        // Use transferFrom as this contract
        IERC20(address(nonStandardToken)).transferFrom(alice, bob, 300 ether);

        // Verify balances
        assertEq(nonStandardToken.balanceOf(alice), 700 ether);
        assertEq(nonStandardToken.balanceOf(bob), 300 ether);

        // Verify allowance was reduced
        assertEq(nonStandardToken.allowance(alice, address(this)), 200 ether);
    }

    function testInfiniteApproval() public {
        // Set max approval for both tokens
        vm.startPrank(alice);
        IERC20(address(standardToken)).approve(address(this), type(uint256).max);
        IERC20(address(nonStandardToken)).approve(address(this), type(uint256).max);
        vm.stopPrank();

        // Transfer some tokens via transferFrom
        IERC20(address(standardToken)).transferFrom(alice, bob, 100 ether);
        IERC20(address(nonStandardToken)).transferFrom(alice, bob, 100 ether);

        // Check that allowance remains at max
        assertEq(standardToken.allowance(alice, address(this)), type(uint256).max);
        assertEq(nonStandardToken.allowance(alice, address(this)), type(uint256).max);

        // Verify balances
        assertEq(standardToken.balanceOf(bob), 100 ether);
        assertEq(nonStandardToken.balanceOf(bob), 100 ether);
    }

    function test_RevertWhen_InsufficientBalance() public {
        vm.startPrank(alice);

        // Try to transfer more than Alice has
        vm.expectRevert("Insufficient balance");
        IERC20(address(standardToken)).transfer(bob, 2000 ether);

        vm.stopPrank();
    }

    function test_RevertWhen_InsufficientAllowance() public {
        vm.startPrank(alice);

        // Set limited approval
        IERC20(address(standardToken)).approve(address(this), 50 ether);

        vm.stopPrank();

        // Try to transfer more than approved
        vm.expectRevert("Insufficient allowance");
        IERC20(address(standardToken)).transferFrom(alice, bob, 100 ether);
    }
}

// A contract that uses our lean IERC20 interface
contract TokenConsumer {
    IERC20 public token;

    constructor(IERC20 _token) {
        token = _token;
    }

    function doTransfer(address to, uint256 amount) external {
        token.transfer(to, amount);
    }

    function doApprove(address spender, uint256 amount) external {
        token.approve(spender, amount);
    }

    function doTransferFrom(address from, address to, uint256 amount) external {
        token.transferFrom(from, to, amount);
    }
}

// Test showing a contract consuming the interface
contract TokenConsumerTest is Test {
    StandardMockERC20 standardToken;
    NonStandardMockERC20 nonStandardToken;
    TokenConsumer standardConsumer;
    TokenConsumer nonStandardConsumer;

    address alice = address(0x1);
    address bob = address(0x2);

    function setUp() public {
        standardToken = new StandardMockERC20();
        nonStandardToken = new NonStandardMockERC20();

        standardConsumer = new TokenConsumer(IERC20(address(standardToken)));
        nonStandardConsumer = new TokenConsumer(IERC20(address(nonStandardToken)));

        // Fund consumer contracts
        standardToken.mint(address(standardConsumer), 1000 ether);
        nonStandardToken.mint(address(nonStandardConsumer), 1000 ether);

        // Fund Alice for transferFrom tests
        standardToken.mint(alice, 500 ether);
        nonStandardToken.mint(alice, 500 ether);
    }

    function testConsumerStandardTransfer() public {
        uint256 bobBalanceBefore = standardToken.balanceOf(bob);

        // Consumer transfers to Bob
        standardConsumer.doTransfer(bob, 100 ether);

        // Verify transfer
        assertEq(standardToken.balanceOf(bob), bobBalanceBefore + 100 ether);
        assertEq(standardToken.balanceOf(address(standardConsumer)), 900 ether);
    }

    function testConsumerNonStandardTransfer() public {
        uint256 bobBalanceBefore = nonStandardToken.balanceOf(bob);

        // Consumer transfers to Bob
        nonStandardConsumer.doTransfer(bob, 100 ether);

        // Verify transfer
        assertEq(nonStandardToken.balanceOf(bob), bobBalanceBefore + 100 ether);
        assertEq(nonStandardToken.balanceOf(address(nonStandardConsumer)), 900 ether);
    }

    function testConsumerTransferFrom() public {
        // Approve consumers to spend Alice's tokens
        vm.startPrank(alice);
        standardToken.approve(address(standardConsumer), 200 ether);
        nonStandardToken.approve(address(nonStandardConsumer), 200 ether);
        vm.stopPrank();

        // Consumers transfer from Alice to Bob
        standardConsumer.doTransferFrom(alice, bob, 150 ether);
        nonStandardConsumer.doTransferFrom(alice, bob, 150 ether);

        // Verify transfers happened
        assertEq(standardToken.balanceOf(alice), 350 ether);
        assertEq(standardToken.balanceOf(bob), 150 ether);

        assertEq(nonStandardToken.balanceOf(alice), 350 ether);
        assertEq(nonStandardToken.balanceOf(bob), 150 ether);
    }
}
