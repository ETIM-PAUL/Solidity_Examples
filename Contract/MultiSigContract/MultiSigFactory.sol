// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

import "./MultiSig.sol";

contract FactoryMultiSig {
    MultiSig[] public multiSig;

    event CloneSuccessfully(bool _success);

    function createMultiSig(
        address[] memory _clonedSigAdmins
    ) external returns (bool success) {
        MultiSig newMultiSig = new MultiSig(_clonedSigAdmins);
        multiSig.push(newMultiSig);
        success = true;
        emit CloneSuccessfully(success);
    }

    function getClonedMultiSigAddress(
        uint index
    ) external view returns (MultiSig _address) {
        _address = multiSig[index];
    }
}
