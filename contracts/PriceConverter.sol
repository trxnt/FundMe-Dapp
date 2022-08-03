// Library attatched to uint256
// Library = similar to a smart contract
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

//import AggregatorV3Interface
//interfaces provide functions for a contract to be appended to
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    // Get ETH conversion 
    function getPrice() internal view returns(uint256) {
        // Address 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e -> ETH / USD Datafeed contract
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH in USD
        // 3000.00000000
        return uint256(price * 1e10); // 1**10 == 10000000000
    }

    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        // 3000_000000000000000000 = ETH / USD
        // 1_000000000000000000 ETH

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // 3000
        return ethAmountInUsd;
    }
}
