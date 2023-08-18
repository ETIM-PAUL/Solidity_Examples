//SPDX-License-Identifier: GPL - 3.0

pragma solidity ^0.8.17;

contract Token {
    string tokenName;
    uint totalSupply;
    mapping(address => uint) public spenders;
    Spender[] listSpenders;

    struct Spender {
        address _add;
        bool exists;
    }

    constructor(string memory _tokenName, uint _totalSupply) {
        tokenName = _tokenName;
        totalSupply = _totalSupply;
    }

    function addAddress(address _new) public {
        if (listSpenders.length > 6) {
            revert("Maximum number of spenders reached");
        } else {
            Spender memory spender = Spender(_new, true);
            listSpenders.push(spender);
        }
    }

    function removeSpender(uint index) public {
        listSpenders[index] = listSpenders[listSpenders.length - 1];
        // Remove the last element
        listSpenders.pop();
        // delete students[index];
    }

    function assignedSpender(
        address spender,
        uint amountToSpend,
        uint index
    ) public {
        require(listSpenders[index].exists, "Spender does not exist.");
        spenders[spender] = amountToSpend;
    }
}
