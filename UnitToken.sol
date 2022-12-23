// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UnitToken is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(address => uint256[]) private _userOwnedTokenIds;

    constructor(address exchangeOperatorCA) ERC721("UnitToken", "UNT") {
        uint256 MINT_SIZE = 20;
        for (uint256 idx = 0; idx < MINT_SIZE; idx++) {
            safeMint(msg.sender);
            // _safeMint(msg.sender, idx);
        }
        setApprovalForAll(exchangeOperatorCA, true);
    }

    function _baseURI() internal view override returns (string memory) {
        return "https://ggyu/";
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
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

    function getTokensURI(address account)
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
