//this Script is going to do FUNDING and WITHDRAWING
// run command: forge script script/Interactions.s.sol --rpc-url <RPC_URL> --broadcast -vvv

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
import {console} from "forge-std/console.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 0.1 ether;

    function FundFundMeFunction(address mostRecendDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecendDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    // this function search in the chain for the most recent deployment of FundMe contract
    // and then it calls the FundFundMeFunction with that address
    //because we have the InteractionsTest contract in multiple places run() will be ignored because we call fundFundMeFunction directly with the address of the deployed contract

    function run() external {
        address mostRecendDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        FundFundMeFunction(mostRecendDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMeInteractions(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();
    }

    // this function search in the chain for the most recent deployment of FundMe contract
    // and then it calls the FundFundMeFunction with that address
    //because we have the InteractionsTest contract in multiple places run() will be ignored because we call withdrawFundMeInteractions directly with the address of the deployed contract
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMeInteractions(mostRecentDeployed);
    }
}
