// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./nft.sol";

contract NftExchanger {
    event ApplySale(address indexed applyer, uint256, uint256);
    event Sale(address indexed buyer, address indexed seller, uint256, uint256);

    struct SaleInfo {
        address onwer;
        uint256 tokenId;
        uint256 price;
    }

    mapping(address => mapping(uint256 => SaleInfo)) private _sales;

    function transferFrom(
        address _tokenCA,
        address from,
        address to,
        uint256 tokenId
    ) public returns (bool) {
        (bool success, bytes memory data) = _tokenCA.call(
            abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                from,
                to,
                tokenId
            )
        );
        return success;
    }

    function applySale(
        address _tokenCA,
        uint256 tokenId,
        uint256 price
    ) public {
        address owner = msg.sender;
        _sales[_tokenCA][tokenId] = SaleInfo(owner, tokenId, price);
        emit ApplySale(owner, tokenId, price);
    }

    function getSales(address _tokenCA, uint256 tokenId)
        public
        view
        returns (
            address,
            uint256,
            uint256
        )
    {
        SaleInfo memory _sale = _sales[_tokenCA][tokenId];
        address _owner = _sale.onwer;
        uint256 _tokenId = _sale.tokenId;
        uint256 _price = _sale.price;

        return (_owner, _tokenId, _price);
    }

    function buySale(address _tokenCA, uint256 tokenId) public payable {
        (address _owner, uint256 _tokenId, uint256 _price) = getSales(
            _tokenCA,
            tokenId
        );
        require(_price == msg.value);
        address payable seller = payable(_owner);
        address buyer = msg.sender;
        seller.transfer(msg.value);
        transferFrom(_tokenCA, seller, buyer, tokenId);
        delete _sales[_tokenCA][_tokenId];
        emit Sale(buyer, seller, _tokenId, _price);
    }
}
