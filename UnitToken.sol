// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UnitToken is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 private _MAX;
    uint256 private _start;
    uint256[] public tokenIds;

    mapping(address => uint256[]) private _userOwnedTokenIds;

    // constructor(address exchangeOperatorCA) ERC721("UnitToken", "UNT") {
    constructor(uint256 maxMint) ERC721("UnitToken", "UNT") {
        // uint256 MINT_SIZE = 20;
        // for (uint256 idx = 0; idx < MINT_SIZE; idx++) {
        //     safeMint(msg.sender);
        //     // _safeMint(msg.sender, idx);
        // }
        // setApprovalForAll(exchangeOperatorCA, true);

        _MAX = maxMint;
        _start = getRandomNumber();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://localhost:3000/unitNft/";
    }

    function getRandomNumber() public view onlyOwner returns (uint256) {
        uint256 rand = uint256(
            keccak256(
                abi.encodePacked(msg.sender, block.number, block.timestamp)
            )
        ) % _MAX;
        return rand;
    }

    function safeMint(address to) public onlyOwner returns (uint256) {
        require(_tokenIdCounter.current() < _MAX, "max mint");
        uint256 tokenId = ((_start + _tokenIdCounter.current()) % _MAX) + 1;
        _tokenIdCounter.increment();
        tokenIds.push(tokenId);
        _safeMint(to, tokenId);
        return tokenId;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
        _userOwnedTokenIds[to].push(tokenId);
    }

    function getOwnedTokenIds(address account)
        public
        view
        returns (uint256[] memory)
    {
        return _userOwnedTokenIds[account];
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getTokenURIs(address account)
        public
        view
        returns (string[] memory)
    {
        uint256[] memory tokenIds = getOwnedTokenIds(account);
        string[] memory uris = new string[](tokenIds.length);

        for (uint256 idx = 0; idx < tokenIds.length; idx++) {
            uris[idx] = tokenURI(tokenIds[idx]);
        }
        return uris;
    }
}
