// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

// ETH
function safeTransferETH(address to, uint amt) {
    (bool success,) = to.call{value: amt}('');
    if (!success) revert();
}

// ERC20
function safeApprove(address tkn, address to, uint amt) {
    (bool success, bytes memory data) =
        tkn.call(abi.encodeWithSignature('approve(address,uint)', to, amt));
    if (!success || (data.length != 0 && !abi.decode(data, (bool)))) {
        revert();
    }
}

function safeTransfer(address token, address to, uint amt) {
    (bool success, bytes memory data) = token.call(
        abi.encodeWithSignature('transfer(address,uint)', to, amt)
    );
    if (!success || (data.length != 0 && !abi.decode(data, (bool)))) {
        revert();
    }
}

function safeTransferFrom(address tkn, address by, address to, uint amt) {
    (bool success, bytes memory data) = tkn.call(
        abi.encodeWithSignature(
            'transferFrom(address,address,uint)', by, to, amt
        )
    );
    if (!success || (data.length != 0 && !abi.decode(data, (bool)))) {
        revert();
    }
}
