//SPDX-License-Identifier: GPL - 3.0

pragma solidity ^0.8.5;

contract Mapping {
    struct Student {
        uint number;
        string name;
        uint age;
        bool good;
        bool exist;
    }

    mapping(address => Student) public studentAdd;

    function mappedAddress(
        Student calldata studentDetails,
        address _add
    ) external {
        studentAdd[_add] = studentDetails;
        studentAdd[_add].exist = true;
    }

    function removeMap(address _addr1) public {
        delete studentAdd[_addr1];
    }

    function setSpecific(string memory _name, uint _age, address _add) public {
        if (studentAdd[_add].exist) {
            studentAdd[_add].name = _name;
            studentAdd[_add].age = _age;
        } else revert("Student doesn't exist");
    }
}
