// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

abstract contract contractA {
string name = "Mars";
  function getName() public view returns (string memory){
    return name;
  }
  function setName(string memory _name) public virtual;
  function defaultName() public virtual {
    name = "";
  }
}

//the above contract is an abstract contract, It can't be deployed. It can't be compiled. It has one unimplemented function.

contractB is contractA { //this contract is built based on the abstract contract contractA
string name = "Jupiter";
  function getName() public view returns (string memory){
     return name;   
   }
  function setName(string memory _newName) public overide virtual {
    name = _newName;
  } 
}