// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

contract Array {
    struct Student {
        string name;
        uint score;
        bool pass;
    }

    Student[] public students;

    function addStudent(Student calldata _details) public {
        if (students.length > 6) {
            revert("Maximum number of students reached");
        } else {
            students.push(_details);
        }
    }

    function removeStudent(uint index) public {
        students[index] = students[students.length - 1];
        // Remove the last element
        students.pop();
        // delete students[index];
    }

    function returnStudent(uint _index) external view returns (Student memory) {
        return students[_index];
    }
}
