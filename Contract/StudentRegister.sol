// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract ClassTask {
    address adminOwner;
    struct Student {
        string name;
        uint age;
        string class;
        bool exist;
    }
    mapping(uint => Student) public students;

    constructor(address _admin) {
        adminOwner = _admin;
    }

    modifier AdminOnly() {
        require(
            msg.sender == adminOwner,
            "Only an Admin can carry out this functionality"
        );
        _;
    }

    function addStudent(
        Student calldata _details,
        uint _regNum
    ) public AdminOnly {
        students[_regNum] = _details;
        students[_regNum].exist = true;
    }

    function removeStudent(uint _regNum) public AdminOnly {
        delete students[_regNum];
    }

    function updateStudentName(
        string memory _name,
        uint _regNum
    ) public AdminOnly {
        if (students[_regNum].exist) {
            students[_regNum].name = _name;
        } else revert("Student doesn't exist");
    }

    function updateStudentAge(uint _age, uint _regNum) public AdminOnly {
        if (students[_regNum].exist) {
            students[_regNum].age = _age;
        } else revert("Student doesn't exist");
    }

    function updateStudentClass(
        string memory _class,
        uint _regNum
    ) public AdminOnly {
        if (students[_regNum].exist) {
            students[_regNum].class = _class;
        } else revert("Student doesn't exist");
    }
}
