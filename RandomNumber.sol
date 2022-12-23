// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract RandomNumber {
    uint256 public randomNumber;
    uint256 public max;
    uint256 public start;

    constructor() {
        max = 50;
    }

    function getRandomNumber() public returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(msg.sender, block.number))) % max;
        // uint256 rand = uint256(keccak256(abi.  (msg.sender, block.number)));
        return rand;
    }
}
