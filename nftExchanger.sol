// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NftExchanger {
    event ApplySale(address indexed applyer, uint256, uint256);
    event Sale(address indexed buyer, address indexed seller, uint256, uint256);
    event TransferFrom(
        string CA,
        address indexed from,
        address indexed to,
        uint256
    );
    event CheckId(address indexed CA);

    struct SaleInfo {
        address onwer;
        uint256 tokenId;
        uint256 price;
    }
    mapping(string => address) public nftList;

    mapping(address => mapping(uint256 => SaleInfo)) private _sales;

    function transferFrom(
        string memory nftKey,
        address from,
        address to,
        uint256 tokenId
    ) public returns (bool) {
        (bool success, bytes memory data) = nftList[nftKey].call(
            abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                from,
                to,
                tokenId
            )
        );
        emit CheckId(nftList[nftKey]);
        emit TransferFrom(nftKey, from, to, tokenId);
        return success;
    }

    function makeTransfer(
        string memory key,
        address from,
        address to,
        uint256 tokenId
    ) public {
        IERC721(nftList[key]).transferFrom(from, to, tokenId);
    }

    function addNftList(string memory key, address CA) public {
        nftList[key] = CA;
    }

    function getNftList(string memory key) public view returns (address) {
        return nftList[key];
    }

    function applySale(
        string memory nftKey,
        uint256 tokenId,
        uint256 price
    ) public {
        require(
            IERC721(nftList[nftKey]).ownerOf(tokenId) == msg.sender,
            "nft owner != msg.sender"
        );
        address owner = msg.sender;
        _sales[nftList[nftKey]][tokenId] = SaleInfo(owner, tokenId, price);
        emit ApplySale(owner, tokenId, price);
    }

    function getSales(string memory nftKey, uint256 tokenId)
        public
        view
        returns (
            address,
            uint256,
            uint256
        )
    {
        SaleInfo memory _sale = _sales[nftList[nftKey]][tokenId];
        address _owner = _sale.onwer;
        uint256 _tokenId = _sale.tokenId;
        uint256 _price = _sale.price;

        return (_owner, _tokenId, _price);
    }

    function buySale(string memory nftKey, uint256 tokenId) public payable {
        (address _owner, uint256 _tokenId, uint256 _price) = getSales(
            nftKey,
            tokenId
        );
        require(_price == msg.value);
        address payable seller = payable(_owner);
        address buyer = msg.sender;
        seller.transfer(msg.value);
        // transferFrom(nftKey, seller, buyer, tokenId);
        makeTransfer(nftKey, _owner, buyer, tokenId);
        delete _sales[nftList[nftKey]][_tokenId];
        emit Sale(buyer, seller, _tokenId, _price);
    }
}
