//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/Test.sol";

contract MoodNFT is ERC721 {
    error MoodNFT__CantFlipMoodIfApprovedOrOwner();
    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) s_tokenIdToMood;
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToURI;
    string private s_sadSVGImageUri;
    string private s_happySVGImageUri;

    constructor(string memory _sadSVGImageUri, string memory _happySVGImageUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSVGImageUri = _sadSVGImageUri;
        s_happySVGImageUri = _happySVGImageUri;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenIdToURI[s_tokenCounter] = tokenURI(s_tokenCounter);
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySVGImageUri;
        } else {
            imageUri = s_sadSVGImageUri;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "descritption":"NFT changes with mood", "attributes": [{"trait_type": "moodines", "value": 100}], "image": "',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function flipMood(uint256 tokenId)public {
       
        if (ownerOf(tokenId) != msg.sender) {
            revert MoodNFT__CantFlipMoodIfApprovedOrOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId]  = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId]  = Mood.HAPPY;
        }
    }

    function getTokenMood(uint256 tokenId) public view returns(Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
