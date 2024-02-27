// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract socialGasNFT is ERC721URIStorage {
    using Strings for uint256;

    uint256 private _tokenIds;
    string private name;
    string private symbol;

    function constructNewNFT()(string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;

        mint();
    }

    function generateLoveBirds(
        uint256 _tokenId
    ) public pure returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">'
            "<style>.base { fill: white; font-family: sans-serif; font-size: 18px; }</style>"
            '<rect width="100%" height="100%" fill="#339af0" />'
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">LoveBirds</text>'
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">Symbol: LB-OlamiTobi',
            Strings.toString(_tokenId),
            "</text>"
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xlm;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTokenURI(uint256 _tokenId) public pure returns (string memory) {
        string memory newID = Strings.toString(_tokenId);

        bytes memory dataURI = abi.encodePacked(
            "{"
            '"name": "',name,' #',
            newID,
            '",',
            '"description":"',newID,'"',
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
        _tokenIds = _tokenIds + 1;

        _safeMint(msg.sender, _tokenIds);

        _setTokenURI(_tokenIds, getTokenURI(_tokenIds));
    }
}
