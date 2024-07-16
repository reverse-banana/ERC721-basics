// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract MoodNftIntergration is Test {
    MoodNft moodNft;
    DeployMoodNft deployMoodNft;
    // with specifing the visibility var will be converted to ht einternal by defaults

    string public sadSvgNftUri = vm.readFile("./nftUri/sadNftUriBaseValue.svg");

    address USER = makeAddr("user");

    // function test set up the test contract instance with related deps if it's needed
    function setUp() public {
        deployMoodNft = new DeployMoodNft();
        moodNft = deployMoodNft.run();
    }

    function testViewTokenUriIntergration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testSadUriValue() public {
        vm.prank(USER);
        moodNft.mintNft();
        MoodNft.Mood mood = moodNft.getMood(0);
        moodNft.tokenURI(0);
        // another way of fetching
        // MoodNft.Mood mood = moodNftInstance.s_tokenIdToMood[tokenId];
        //**When you declare a variable with the syntax MoodNft
        //Mood mood, you're telling Solidity that mood is a variable of type Mood, which is defined inside the MoodNft contract.  */

        vm.prank(USER);
        moodNft.flipMood(0);
        mood = moodNft.getMood(0);

        moodNft.tokenURI(0);
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();
        // actually minting the nft

        vm.prank(USER);
        moodNft.flipMood(0);
        // flipping the mood value of the provided toke id (it's zero cause it's been deployed first)

        assertEq(keccak256(abi.encodePacked(moodNft.tokenURI(0))), keccak256(abi.encodePacked(sadSvgNftUri)));
    }
}
