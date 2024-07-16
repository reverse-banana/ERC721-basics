// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.sol";
import {BasicNft} from "src/BasicNft.sol";

contract DeployBasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    // declating the vars of the imported contracts objects
    // so we could do: deployer = new DeployBasicNft();
    // instead of the: DeployBasicNft deployBasicNfr = new DeployBasicNfr();

    address public USER = makeAddr("user");
    uint256 public STARTING_BALANCE = 100 ether;
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
        // assigning the value of the returned object of run() runs to the var in the test
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));

        // due to the fact that we can only compare the prim types of data
        // such as: uint bool bytes etc (the string is an array of bytes)
        // the workaroung is to hash the values of the array with abi.encode
        // and then compare the hashes of the arrays beetween each other
        // for this we firstly typecast it to dynamic bytes and then hash it with keccak
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        // checking that user minted it's nft
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
        // checing that token uri is correspond to the providede one
        // don't forget that we are still have all token and it's data with owners mapped in our contract
    }
}
