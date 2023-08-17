//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe  is Script{
     function run() public returns(FundMe){
        //before broadcast
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        
        vm.startBroadcast();
         FundMe fundme = new FundMe(ethUsdPriceFeed);
         vm.stopBroadcast();
         return fundme;
    }
}
