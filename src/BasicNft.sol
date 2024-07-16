// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;

    mapping(uint256 => string) private s_tokenIdToUri;
    // mappings to id to it's uri

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
        // here we are just initing erc721 as entity with it's name and sumbol without any minting
        // and also setting counter will will increment during actual mint operation
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        // minting to the msg.sender the coin with the value of s_tokenCounter
        // and the reason why we didn't defined and in reality could define the tokenUri param in the code
        // is just a nature of nft itself where we giveoppurtinity to customize it uri for msg.sender

        s_tokenCounter++;
    }

    // for lets think about it as the getter function for the object prperies in format of uri
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
