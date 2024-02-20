// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IERC20 {
  function transfer(address to, uint value) external returns (bool);
}

contract BadERC20 {
    function transfer(address, uint) external pure {
        return;
    }
}

contract Test {
    function testIt() external {
        BadERC20 bad = new BadERC20();
        IERC20(address(bad)).transfer(address(this), 0); // It reverts
    }
}