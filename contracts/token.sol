// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MugglePay is ERC20 {
    uint256 private constant TOTAL_SUPPLY = 1000 * 10**18; // 1,000 tokens with 18 decimal places

    constructor() ERC20("MugglePay", "MPay") {
        _mint(msg.sender, TOTAL_SUPPLY);
    }
}