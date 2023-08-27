// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MyERc20 {
    string tokenName;
    string tokenSymbol;
    uint totalSupply;
    uint constant Decimal = 1e18;

    mapping(address => uint) _balance;
    mapping(address => mapping(address => uint)) allowance;

    event Transfer(address to, uint sentValue);
    event Approval(address _from, address _to, uint approvedValue);

    constructor(string memory _tokenName, string memory _tokenSymbol) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
    }

    function setTotalSupply(uint _total) external {
        totalSupply = _total * Decimal;
    }

    function balanceOf(address _of) public view returns (uint yourBalance) {
        yourBalance = _balance[_of];
    }

    function transfer(address _to, uint value) public {
        require(_to != address(0), "Zero Address");
        require(_balance[msg.sender] >= value, "Insufficient Funds");
        require(value > 0, "Value must be greater than zero");

        _balance[msg.sender] -= value;
        _balance[_to] += value;

        emit Transfer(_to, value);
    }

    function approve(address _approveAddress, uint amountApprove) public {
        require(_approveAddress != address(0), "Zero Address");
        require(amountApprove > 0, "Value must be greater than zero");
        require(msg.sender != _approveAddress, "You can't approve your self");
        allowance[msg.sender][_approveAddress] += amountApprove;
    }

    function transferFrom(address from, address to, uint amountTo) public {
        require(from != address(0), "Zero Address");
        require(to != address(0), "Zero Address");
        require(
            allowance[from][msg.sender] >= amountTo,
            "Insufficent Allowance"
        );
        require(_balance[from] >= amountTo, "Insufficent Balance");

        allowance[from][msg.sender] -= amountTo;
        _balance[from] -= amountTo;
        _balance[to] += amountTo;
        emit Approval(from, to, amountTo);
    }

    function allowanceSet(
        address _owner,
        address _spender
    ) public view returns (uint _allowance) {
        _allowance = allowance[_owner][_spender];
    }

    function mintToken(address mintAddress, uint value) public {
        require(mintAddress != address(0), "Zero Address");
        totalSupply += value;
        _balance[mintAddress] += value;
    }

    function burnToken(uint value) public {
        totalSupply -= value;
        _balance[msg.sender] -= value;
    }
}
