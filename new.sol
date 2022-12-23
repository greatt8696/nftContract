// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract New is ERC20 {
    constructor() ERC20("New", "MTK") {}
}