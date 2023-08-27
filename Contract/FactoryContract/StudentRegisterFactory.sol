// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./StudentRegister.sol";

contract StudentRegisterFactory {
    function createStudentRegister()
        external
        returns (ClassTask classRegister)
    {
        classRegister = new ClassTask(msg.sender);
    }
}
