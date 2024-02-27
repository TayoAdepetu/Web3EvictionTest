// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./deployedNFTABI.sol";

contract socialGasFactory {
    deployedNFTABI public deployedContract;

    address public _deployedContractAddress =
        "0x909532D0979BDF52DA7bB389BBa4Bd95321c9018";

    function createSocialGasPost(
        string memory _name,
        string memory _symbol
    ) external pure returns (string memory) {
        deployedContract = deployedNFTABI(_deployedContractAddress);
        deployedContract.constructNewNFT();
    }
}
