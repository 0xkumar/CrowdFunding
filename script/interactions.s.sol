//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
//fund
//withdraw
import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/Fundme.sol";


contract FundFundMe is Script {

    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        
        FundMe(payable(mostRecentlyDeployed)).fund{value:SEND_VALUE}(); 
        
        vm.stopBroadcast();
        
        console.log("Funded fundMe with %s",SEND_VALUE);
    }

    function run () external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("fundme",block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }


    }

contract WithdrawFundMe is Script{
    function WithdraFundMe(address mostRecentlyDeployed) public {

        vm.startBroadcast();
        
        FundMe(payable(mostRecentlyDeployed)).withdraw(); 
        
        //console.log("Funded fundMe with %s",SEND_VALUE);
        vm.stopBroadcast();
    }

    function run () external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("fundme",block.chainid);
        vm.startBroadcast();
        WithdraFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }

}

