// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    // set minimum USD
    uint256 public minimumUSD = 50 * 1e18; // 1 * 10 ** 18

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // global variable 
    address public owner;

    /* constructor - gets called immediately when the contract is deployed */
    constructor (){
        // msg.sender of construction function is the deployer of the contract
        owner = msg.sender;
    }

    // fund contract address
    function fund() public payable {
        // 1. How do we send ETH to this contract? requires at least 1 ETH 
        // if first part of require is not met, revert to second condition and return remaining gas
        require (msg.value.getConversionRate() >= minimumUSD, "Didn't send enough eeeeth"); // 1e18 == 1 * 10 ** 18 
        // .sender is the address of whoever calls the fund function
        // keep track of senders who fund the contract
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    // withdraw funds out of the contract
    function withdraw() public onlyOwner{
            // loop though index and grab funder and reset AmountFunded to 0
            /*  for (starting index, ending index, step amount)
                for (start at 0, end at 10, increment by 1 each time)  */
            for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) { //funderIndex = funderIndex + 1;
            // return address of funder from index
            address funder = funders[funderIndex];
            // reset our mapping back to 0 since the contact is being withdrawn
            addressToAmountFunded[funder] = 0;
        }

        // Reset the array
        // funders array = new address array with 0 items in it
        funders = new address[](0);
        // Actually withdraw the funds

        // 3 ways to send native blockchain currency:
        // Transfer - automatically reverts if the transfer fails
        payable(msg.sender).transfer(address(this).balance);

        // Send - will only revert the transaction with the require statment
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
            require (sendSuccess, "Dang, send failed");

        // Call - requires callSuccess to be true, otherwise reverts to error call failed
        /* Call is currently the reccomended way to send and recieve native tokens */
       (bool callSuccess, ) =  payable(msg.sender).call{value: address(this).balance}("");
            require (callSuccess, "Dang, call failed");

    }

    
    // modifier - add keyword to funtion declaration so that the modifers code runs before the function
    modifier onlyOwner{
            require (msg.sender == owner, "Sender is not onwer");
            // signals to do the rest of the function 
            _;

    }


}