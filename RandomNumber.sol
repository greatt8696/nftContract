// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/utils/Counters.sol";

contract RandomNumber {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 public max;
    uint256 public start;

    uint256[] public tokenIds;

    event Check(
        uint256 _tokenId,
        uint256 max,
        uint256 start,
        uint256[] tokenIds
    );

    constructor() {
        max = 10;
        start = getRandomNumber();
    }

    function getRandomNumber() public view returns (uint256) {
        uint256 rand = uint256(
            keccak256(
                abi.encodePacked(msg.sender, block.number, block.timestamp)
            )
        ) % max;
        // uint256 rand = uint256(keccak256(abi.  (msg.sender, block.number)));
        return rand;
    }

    function mintNft() public returns (uint256) {
        require(_tokenIdCounter.current() < max, "max mint");
        uint256 tokenId = ((start + _tokenIdCounter.current()) % max) + 1;
        _tokenIdCounter.increment();
        tokenIds.push(tokenId);
        emit Check(tokenId, max, start, tokenIds);
        return tokenId;
    }

    function getCounter() public view returns (uint256) {
        return _tokenIdCounter.current();
    }
}
