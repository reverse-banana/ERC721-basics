// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";

contract MoodNftTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployMoodNft;

    function setUp() external {
        deployMoodNft = new DeployMoodNft();
    }

    function testConvertSvgToURI() public view {
        string memory expectedUri = vm.readFile("./img/happybase.svg");

        string memory svg = vm.readFile("./img/happy.svg");

        string memory actualUri = deployMoodNft.svgToImageURI(svg);
        console.log("Expected URI", expectedUri);
        console.log("ActualUri", actualUri);
        assert(keccak256(abi.encodePacked(actualUri)) == keccak256(abi.encodePacked(expectedUri)));
    }

    function testUriFormat() public view {}
}
