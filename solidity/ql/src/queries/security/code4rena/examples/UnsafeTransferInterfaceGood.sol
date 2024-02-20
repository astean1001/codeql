// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

interface IERC20 {
  function transfer(address to, uint value) external returns (bool);
}

contract BadERC20 {
    function transfer(address, uint) external pure {
        return;
    }
}

contract Test {
    using SafeERC20 for IERC20;

    function testIt() external {
        BadERC20 bad = new BadERC20();
        IERC20(address(bad)).safeTransfer(address(this), 0);
    }
}