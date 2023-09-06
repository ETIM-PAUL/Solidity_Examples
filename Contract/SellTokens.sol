//SPDX-License-Identifier: MIT

import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

pragma solidity 0.8.21;

contract StandardToken is ERC20 {
    constructor() ERC20("JOE Tokens", "Joe") {
        _mint(address(this), 10_000e8);
    }

    // 20000e18
    uint ExpectedAmount = 10_000 ether;
    uint precision = 1e32;

    function decimals() public view override returns (uint8) {
        return 8;
    }

    function buyTokens() external payable returns (uint tokensBought) {
        //This calls the exchangeRate Function we created and then saves the
        // returned rate in exchange
        uint _exchange = exchangeRate();

        //this calculates the amount you will get based on the ethers you are paying
        uint amount = (msg.value * _exchange) / precision;

        //remember the openZepellin code, we imported. We will utilize its transfer
        //method that transfer tokens from the owner to another account
        _transfer(address(this), msg.sender, amount);
    }

    function exchangeRate(uint value) internal returns (uint rate) {
        uint precisonCut = 10000e18 * precision;
        rate = (precisonCut / expectedTotalEthers);
    }

    function returnBalance()
        external
        view
        returns (uint etherbalance, uint tokenBalance)
    {
        //This returns the amount of ethers our contract holds
        etherbalance = address(this).balance;

        //This returns the amount of tokens in our contract
        tokenBalance = balanceOf(address(this));
    }

    function withdrawEther() external {
        // this checks to make sure only contract owner can withdraw;
        require(msg.sender == owner, "Only Owner");

        //this transfers the ethers to the account that calls the functions
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "transferFailed");
    }
}
