//SPDX-License_Identifier: MIT

pragma solidity ^0.8.19;
import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/Fundme.sol";
import {helperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    FundMe fundme;
    helperConfig config;

    // struct mainnetchainID{
    //     address pricefeed;
    //     address vrfcoordinator;
    // }

    function run() external returns (FundMe) {
        config = new helperConfig();
        //mainnetchainID memory mainh = config.activeChainId();
        (address pricefeed) = config.activeChainId();


        vm.startBroadcast();
        fundme = new FundMe(pricefeed);
        vm.stopBroadcast();
        return fundme;
    }
}



