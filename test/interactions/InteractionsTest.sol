// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../../src/FundMe.sol"; // ../ means go back one directory
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1 ether; // 1 ETH
    uint256 constant STARTING_BALANCE = 10 ether; // 10 ETH
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        vm.prank(USER);

        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        vm.prank(USER);
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.FundFundMeFunction(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMeInteractions(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
