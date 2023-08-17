//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract fundmetest is Test {

    FundMe fundme;
    DeployFundMe deploy;

    function setUp() external {
        //fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deploy = new DeployFundMe();
        fundme = deploy.run();
    }

    function testMinimumUSD () public {
        assertEq(fundme.MINIMUM_USD(),5e18);

    }
    function testownerismsgsender () public {
        console.log(msg.sender);
        console.log(address(this));
        console.log(fundme.i_owner());
        assertEq(fundme.i_owner(),msg.sender);
    }

    function testOwnerIsMsgSender() public {
        uint version = fundme.getVersion();
        console.log(version);
        assertEq(version,4);
    }

    function testdepositMoney() public {
        (bool success,)=address(fundme).call{value:100000000000000000000}("");
        require(success,"transaction failed");
        assertEq(address(this),fundme.funders(0));
    }
    
}
