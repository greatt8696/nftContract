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

    // function transferFrom(
    //     string memory nftnftName,
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) public returns (bool) {
    //     (bool success, bytes memory data) = nftList[nftnftName].call(
    //         abi.encodeWithSignature(
    //             "transferFrom(address,address,uint256)",
    //             from,
    //             to,
    //             tokenId
    //         )
    //     );
    //     emit CheckId(nftList[nftnftName]);
    //     emit TransferFrom(nftnftName, from, to, tokenId);
    //     return success;
    // }

    function makeTransfer(
        string memory nftName,
        address from,
        address to,
        uint256 tokenId
    ) public {
        IERC721(nftList[nftName]).transferFrom(from, to, tokenId);
    }

    function addNftList(string memory nftName, address CA) public {
        nftList[nftName] = CA;
    }

    function getNftList(string memory nftName) public view returns (address) {
        return nftList[nftName];
    }

    function applySale(
        string memory nftnftName,
        uint256 tokenId,
        uint256 price
    ) public {
        require(
            IERC721(nftList[nftnftName]).ownerOf(tokenId) == msg.sender,
            "nft owner != msg.sender"
        );
        address owner = msg.sender;
        _sales[nftList[nftnftName]][tokenId] = SaleInfo(owner, tokenId, price);
        emit ApplySale(owner, tokenId, price);
    }

    function getSales(
        string memory nftnftName,
        uint256 tokenId
    ) public view returns (address, uint256, uint256) {
        SaleInfo memory _sale = _sales[nftList[nftnftName]][tokenId];
        address _owner = _sale.onwer;
        uint256 _tokenId = _sale.tokenId;
        uint256 _price = _sale.price;
        return (_owner, _tokenId, _price);
    }

    function buySale(string memory nftnftName, uint256 tokenId) public payable {
        (address _owner, uint256 _tokenId, uint256 _price) = getSales(
            nftnftName,
            tokenId
        );
        require(_price == msg.value);
        address payable seller = payable(_owner);
        address buyer = msg.sender;
        seller.transfer(msg.value);
        makeTransfer(nftnftName, _owner, buyer, tokenId);
        delete _sales[nftList[nftnftName]][_tokenId];
        emit Sale(buyer, seller, _tokenId, _price);
    }
}
