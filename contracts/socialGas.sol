// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract SocialGas {
    enum Role {
        Normal_User,
        Admin
    }

    struct UserInfo {
        string username;
        string about_user;
        address user_id;
    }

    mapping(address useraccount => string username) public userMap;

    UserInfo[] public allUsers;

    address private owner;

    address private nftFactoryAddress;

    uint256 private symbol;

    constructor(string memory _username, string memory _about_user) {
        owner = msg.sender;
        userMap[msg.sender];

        allUsers.push(UserInfo(_username, _about_user, msg.sender));
    }

    modifier authUser() {
        require(userMap[msg.sender], "Error: you're not a registered user.");
        _;
    }

    function registerUser(
        string memory _username,
        string memory _about_user
    ) public {
        allUsers.push(UserInfo(_username, _about_user, msg.sender));
    }

    function postGas(string memory text) external {
        uint256 realID = symbol;
        symbol = symbol + 1;
        string memory newSymbol = Strings.toString(symbol);

        callNFTFactory(realID);
    }
}
