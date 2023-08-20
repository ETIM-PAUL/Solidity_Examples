//SPDX-License-Identifier: GPL 3.0

pragma solidity ^0.8.17;

contract HelloWorld {
    string text = "Hello World";

    function sendGreetings() public view returns (string memory) {
        return text;
    }
}
