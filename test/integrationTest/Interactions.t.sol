//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {Test,console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {Script} from "forge-std/Script.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,WithdrawFundMe} from "../../script/interactions.s.sol";

contract InteractionTest is Test {

    FundMe fundme;
    DeployFundMe deploy;
    address user = makeAddr("user");
    address ownerAddress;
    uint constant send_value = 1 ether;
    uint constant starting_balance = 10 ether;

     function setUp() external {
        deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(user,starting_balance);
     }

     function testUserCanFund () public {
         //FundFundMe fundFundMe = new FundFundMe();
         //vm.prank(user);
         //vm.deal(user,1e18);
         //fundFundMe.fundFundMe(address(fundme));

         //address funder = fundme.getAddressOfTheFunderByIndex(0);
         //assertEq(funder,user);
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.WithdraFundMe(address(fundme));
        console.log(address(fundme).balance);
        assert(address(fundme).balance == 0);


     }
}


