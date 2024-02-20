// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


contract TransferOnPayableAddressGood {

    address payable public target = payable(0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa);

    constructor() payable {
    }

    function sendEtherwithCall(uint256 amount) public {
        (bool success, ) = target.call{value: amount}("");
        require(success, "Transfer Failed");
    }
}