// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


contract TransferOnPayableAddressBad {

    address payable public target = payable(0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa);
    address test;

    constructor() payable {
    }

    function sendEtherwithTransfer(uint256 amount) public {
        target.transfer(amount);
    }

    function sendEtherwithSend(uint256 amount) public {
        target.send(amount);
    }
}