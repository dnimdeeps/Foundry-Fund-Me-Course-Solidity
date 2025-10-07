//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfigAddress is Script {
    HelperConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8; // because we are using a mock , we assume the price feed has 8 decimal places
    int256 public constant INITIAL_PRICE = 2000e8; // because we are using a mock , we asusme the price of eth is 2000 USD

    struct HelperConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = configSepoliaAddress();
        }
        if (block.chainid == 1) {
            activeNetworkConfig = configMainNetAddress();
        } else {
            activeNetworkConfig = GetOrCreateConfigAnvil();
        }
    }

    function configSepoliaAddress() public pure returns (HelperConfig memory) {
        HelperConfig memory config = HelperConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return config;
    }

    function configMainNetAddress() public pure returns (HelperConfig memory) {
        HelperConfig memory config = HelperConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return config;
    }

    function GetOrCreateConfigAnvil() public returns (HelperConfig memory) {
        //if the price feed address is already set , then we dont need to deploy the mock
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // we want to deploy the mock price feed contract based on chainlink
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        HelperConfig memory anvilConfig = HelperConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
