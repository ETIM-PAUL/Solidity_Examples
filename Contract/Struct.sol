//SPDX-License-Identifier: GPL - 3.0

pragma solidity ^0.8.17;

contract Mapping {
    struct Student {
        uint number;
        string name;
        uint age;
        bool good;
    }

    mapping(address => Student) studentAdd;

    function mappedAddress(
        Student calldata studentDetails,
        address _add
    ) external {
        studentAdd[_add] = studentDetails;
    }

    function get(address _addr1) public view returns (Student memory) {
        return studentAdd[_addr1];
    }

    function removeMap(address _addr1) public {
        delete studentAdd[_addr1];
    }
}
