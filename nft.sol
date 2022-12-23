// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EquipToken is ERC721 {
    event SetApprovalForAll(address, address, bool);
    constructor(address exchangeContract) ERC721("EquipToken", "EQT") {
        _safeMint(msg.sender, 0);
        _safeMint(msg.sender, 1);
        _safeMint(msg.sender, 2);
        _safeMint(msg.sender, 3);
        _safeMint(msg.sender, 4);
        _safeMint(msg.sender, 5);
        _safeMint(msg.sender, 6);
        setApprovalForAll(exchangeContract, true);
    }
}
