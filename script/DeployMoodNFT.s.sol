//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


import {Script, console} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract DeployMoodNFT is Script {
    
    function run() external returns(MoodNFT) {
        string memory sadImage = vm.readFile("./img/sad.svg");
        string memory happyImage = vm.readFile("./img/happy.svg");
        
        vm.startBroadcast();
        MoodNFT moodNft = new MoodNFT(
            base64EncodeSvg(sadImage),
            base64EncodeSvg(happyImage)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    function base64EncodeSvg(string memory svg) internal pure returns(string memory) {
        string memory base64Svg = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string.concat("data:image/svg+xml;base64,", base64Svg);
    }
}