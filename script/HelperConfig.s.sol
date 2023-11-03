//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract helperConfig is Script{

    //address sepolia_address = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
     Network public activeChainId;

     struct Network{
         address priceFeed;
         //address VRFCoordinator;
     } 
     uint8 public Decimals = 8;
     int256 public InitialAnswer = 200000000000;

    constructor() {
        if(block.chainid ==11155111){
            activeChainId = sepoliaNetwork();
            
        }
        else if(block.chainid == 1){
            activeChainId = mainnet();

        }
        else {
            activeChainId = getOrCreateAnvilContracts();
        }

    }

    function sepoliaNetwork() public  pure returns (Network memory) {

        Network memory network = Network({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            //VRFCoordinator: 0x3d2341ADb2D31f1c5530cDC622016af293177AE0
        });

        return network;
    }

    function mainnet() public pure  returns (Network memory){
        Network memory network = Network({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            //VRFCoordinator: 0xf0d54349aDdcf704F77AE15b96510dEA15cb7952
        });
        return network;

    }

    function getOrCreateAnvilContracts() public returns (Network memory){
        if(activeChainId.priceFeed != address(0)){
            return activeChainId;
        }
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(Decimals,InitialAnswer);

        vm.stopBroadcast();

        Network memory network = Network({
        priceFeed : address(mock)
        });
        return network;

    }


}

