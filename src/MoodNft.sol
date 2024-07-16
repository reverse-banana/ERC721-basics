// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/Script.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    // basic convention for id iteration purposes in the constructor
    string private s_sadSvgUri;
    // base 64 format encoded uri value
    string private s_happySvgUri;
    // base 64 format encoded uri value

    enum Mood {
        HAPPY,
        SAD
    }
    // list of the nft states options

    mapping(uint256 => Mood) private s_tokenIdToMood;
    // mapping for assignign the mood status for each of the nfr based on it's id

    mapping(uint256 => address) private s_owners;
    // mapping for assigning the id to the owner address

    constructor(string memory sadSvg, string memory happySvg) ERC721("Mood1 NFT", "MNT") {
        s_tokenCounter = 0;
        s_sadSvgUri = sadSvg;
        s_happySvgUri = happySvg;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        // assigning the nft to msg.sender with the provided id
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        // explicitly setting the enum state (best practice)
        s_owners[s_tokenCounter] = msg.sender;

        s_tokenCounter++;

        console.log(s_tokenCounter);
        // incrementing the counter
    }

    function flipMood(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        if (!_isAuthorized(owner, msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        // declaring the placeholder URI var that will be dynamicly changed bassed on the mood

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgUri;
        } else {
            imageURI = s_sadSvgUri;
        }

        // in order to encode the whole token uri we need to convert it plalintext uri into the  bytes
        // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
        // then we use the imported base64 encoding function
        // for the headers that specify the data type we override the ERC721 _baseURI() func that will return a desired format string
        // due to it's plaintext fromat we also encode it with abi.encodePacked
        // and in the end typecast it to the string in order to fit to the func return type of a string memory

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    // getters

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return s_owners[tokenId];
    }
}
