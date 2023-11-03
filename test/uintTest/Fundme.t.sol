//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {Test,console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {Script} from "../../lib/forge-std/src/Script.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundmeTest is Test {
    FundMe fundme;
    DeployFundMe deploy;
    address ownerAddress;
    uint constant send_value = 1 ether;
    uint constant starting_balance = 10 ether;
    
    address user = makeAddr("user");

    function setUp () external {
        //fundme = new FundMe();
        deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(user,starting_balance);

        //console.log(address(fundme));
    }

    // function TestgetVersion () public {
    //     uint version = fundme.getVersion();
    //     assertEq(version,4);
    // }

    // function setUp() public {
    //     fundme = new FundMe();
    // }

    function testMinimumDollarvalue() public {
        assertEq(fundme.MINIMUM_USD(),5e18);
    }

    function testOwner() public view {
        console.log(msg.sender);
        console.log(address(this));
        console.log(address(fundme));
        console.log(address(deploy));
        //console.log(ownerAddress);



        //assertEq(ownerAddress,address(msg.sender));

    }

    // function check_owner() public {
    //     console.log(fundme.i_owner());
    //     assertEq(fundme.i_owner(),msg.sender);
    // }
    function testgetVersionINfundMe() public {
        console.log(fundme.getVersion());
        assertEq(fundme.getVersion(),4);
    }

    function testrevert_checking() public {
        vm.expectRevert();//the next line have to revert
        //uint cat = 1234;
        fundme.fund();
        
    }

    function testfundfunctionWorking() public {
        //vm.expectRevert();
        console.log(fundme.MINIMUM_USD());
        fundme.fund{value : send_value}();
    }

    function testfundUpdatesFundedDataStructure() public {

        vm.prank(user); //The next transaction will be sent by user
        fundme.fund{value: send_value}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(user);
        assertEq(amountFunded,send_value);
    }

    function testWithdrawOnlyOwner() public view {
        console.log(address(msg.sender));
        console.log(address(deploy));
        console.log(address(this));
        console.log(ownerAddress);
    }

    function testAddsFunderToArray() public {
        vm.prank(user); //The next transaction will be sent by the user
        fundme.fund{value:send_value}();
        address fundedAddress = fundme.getAddressOfTheFunderByIndex(0);

        console.log(fundedAddress);
        console.log(user);

        assertEq(fundedAddress,user);
    }

    modifier funded() {
        vm.prank(user);
        fundme.fund{value:send_value}();
        _;
    }

    function testWithdraw() public funded() {

        vm.prank(user);
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWithDrawWithSingleFunder() public funded {
        //arrange
        //ownerAddress = fundme.getOwner();
        //console.log(fundme.getOwner());
        uint256 ownerBalance = fundme.getOwner().balance;
        console.log(ownerBalance);
        uint256 fundmeBalance = address(fundme).balance;
        console.log(fundmeBalance);



        //Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        // console.log(fundmeBalance);
        // console.log(ownerBalance);
        uint endingBAlance = fundme.getOwner().balance;
        uint endingContractBalance = address(fundme).balance;
        console.log(endingBAlance);
        console.log(endingContractBalance);
        //assert

        assertEq(endingBAlance,ownerBalance + fundmeBalance);
    }

    function testWithDrawWithMultipleFunder() public funded {
        uint numberOfFunders = 10;
        uint256 startingIndexValue = 0;
        for(uint i = startingIndexValue; i < numberOfFunders; i++){
            //vm.prank
            address User = makeAddr("user");
            vm.deal(User,starting_balance);
            vm.prank(User);
            fundme.fund{value:send_value}();
        }
        uint ownerbalance = fundme.getOwner().balance;
        uint contractBalance = address(fundme).balance;
        console.log(ownerbalance);
        console.log(contractBalance);

        uint expectedContractBalance = address(fundme).balance;
        uint expectedOwnerBalance = fundme.getOwner().balance;

        vm.prank(fundme.getOwner());
        fundme.withdraw();

        uint endingOwnerBalance = fundme.getOwner().balance;
        assertEq(expectedContractBalance+expectedOwnerBalance,endingOwnerBalance);
    }


}
