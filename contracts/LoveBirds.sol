// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract LoveBirds is ERC721URIStorage {
    using Strings for uint256;

    enum Status {
        Private,
        Public
    }

    struct NFTInfo {
        string name;
        string symbol;
        address owner;
        uint256 totalSupply;
        Status status;
        uint256 lastID;
        uint256 nftID;
    }

    struct Store {
        string name;
        address owner;
        Status status;
    }

    mapping(address => Store) public userStores;
    mapping(uint256 => NFTInfo) public nftInfo;

    uint256 private _tokenIds;
    uint256 private _storeIds;

    event NFTCreated(
        uint256 indexed nftId,
        string name,
        string symbol,
        address owner,
        uint256 totalSupply,
        Status status
    );
    event StoreCreated(
        uint256 indexed storeId,
        string name,
        address owner,
        Status status
    );

    constructor() ERC721("LoveBirds", "LB-OlamiTobi") {}

    function createNFTStore(string memory _storeName) public {
        require(
            userStores[msg.sender].owner == address(0),
            "You already have a store"
        );
        _storeIds++;
        userStores[msg.sender] = Store(_storeName, msg.sender, Status.Private);
        emit StoreCreated(_storeIds, _storeName, msg.sender, Status.Private);
    }

    function createNFT(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) public returns (uint256) {
        require(
            userStores[msg.sender].owner != address(0),
            "You don't have a store yet"
        );
        _tokenIds++;
        nftInfo[_tokenIds] = NFTInfo(
            _name,
            _symbol,
            msg.sender,
            _totalSupply,
            Status.Private,
            0,
            _tokenIds
        );
        emit NFTCreated(
            _tokenIds,
            _name,
            _symbol,
            msg.sender,
            _totalSupply,
            Status.Private
        );
        return _tokenIds;
    }

    function generateLoveBirds(
        uint256 _tokenId
    ) public pure returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: sans-serif; font-size: 18px; }</style>",
            '<rect width="100%" height="100%" fill="#339af0" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">LoveBirds</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">Symbol: LB-OlamiTobi',
            Strings.toString(_tokenId),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTokenURI(uint256 _tokenId) public view returns (string memory) {
        // require(_exists(_tokenId), "Token does not exist");
        string memory newID = Strings.toString(_tokenId);
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "LoveBirds #',
            newID,
            '",',
            '"description": "Extra-ordinary TeeWhy and KomSEO Love Tales in Pictures ',
            newID,
            '",',
            '"image": "',
            generateLoveBirds(_tokenId),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() external {
        require(
            userStores[msg.sender].owner != address(0),
            "You don't have a store yet"
        );
        uint256 nftId = createNFT("NFT", "N", 1);
        _safeMint(msg.sender, nftId);
        _setTokenURI(nftId, getTokenURI(nftId));
    }

    function buyNFT(uint256 _nftId) external payable {
        require(msg.value > 0, "Please provide a non-zero value");
        require(ownerOf(_nftId) != address(0), "Token does not exist");
        require(ownerOf(_nftId) != msg.sender, "You cannot buy your own NFT");

        address payable seller = payable(ownerOf(_nftId));
        uint256 price = msg.value;

        seller.transfer(price);
        _transfer(seller, msg.sender, _nftId);
    }
}
