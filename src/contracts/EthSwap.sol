//SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.6.0;

import "./DevToken.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    DevToken public dev_token;
    uint256 public rate = 100;

    event TokensPurchased(
        address account,
        address dev_token,
        uint256 amount,
        uint256 rate
    );

    event TokensSold(
        address account,
        address dev_token,
        uint256 amount,
        uint256 rate
    );

    constructor(DevToken _dev_token) public {
        dev_token = _dev_token;
    }

    function buyTokens() public payable {
        //Redempition rate = # of tokens they recive for 1 ether
        //Amount of ETH * Redemption Rate
        //Calculate the number of tokens to buy
        uint256 tokenAmount = msg.value * rate;

        //Require that EthSwap has enough tokens
        require(dev_token.balanceOf(address(this)) >= tokenAmount);

        //Transfer tokens to the user
        dev_token.transfer(msg.sender, tokenAmount);

        //Emit an event
        emit TokensPurchased(msg.sender, address(dev_token), tokenAmount, rate);
    }

    function sellTokens(uint256 _amount) public payable {
        //User can't sell more tokens than they have
        require(dev_token.balanceOf(msg.sender) >= _amount);

        //Calculate the ETH amount to redeem
        uint256 ethAmount = _amount / rate;

        //Require that EthSwap has enough Ether
        require(address(this).balance >= ethAmount);

        //Peform sale
        dev_token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(ethAmount);

        //Emit an event
        emit TokensSold(msg.sender, address(dev_token), _amount, rate);
    }
}
