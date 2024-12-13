//SPDX-License-Identfier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract BasicNFTTest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public constant USER = address(1);

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.deploy();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogo";
        string memory actualName = basicNFT.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testMint() public {
        vm.prank(USER);
        basicNFT.mintNFT(PUG_URI);

        assertEq(keccak256(abi.encodePacked(PUG_URI)), keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
        assertEq(1, basicNFT.balanceOf(USER));
    }
}
