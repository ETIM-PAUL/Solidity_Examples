// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface ERC20Token {
    function balanceOf(address account) external returns (uint);

    function transferFrom(
        address _from,
        address _to,
        uint amount
    ) external returns (bool);

    function buyToken() external returns (uint);

    function approve(address spender, uint256 amount) external;
    // function withdrawEther() external;
}

contract StakeTokens {
    ERC20Token WuraToken;
    struct Staker {
        uint stakedAmount;
        uint firstStakedTime;
        uint hugeStakedValueTimes;
        bool hugeStakedValue;
    }
    mapping(address => Staker) stakedBalance;
    uint private constant HugeStakedValue = 1000;

    constructor() {
        WuraToken = ERC20Token(0x8Bc4b37aff83FdA8a74d2b5732437037B801183e);
    }

    modifier isTokenHolder() {
        uint wuraTokenBalance = WuraToken.balanceOf(msg.sender);
        require(wuraTokenBalance > 0, "You don't have Wura Tokens");
        _;
    }

    function getStakedDetails(
        address staker
    ) public view returns (uint amount) {
        Staker storage _staker = stakedBalance[staker];
        amount = _staker.stakedAmount;
    }

    function buyAndWithdrawWuraTokens()
        external
        payable
        returns (bool, bytes memory)
    {
        (bool success, bytes memory data) = address(WuraToken).call(
            abi.encodeWithSignature("buyToken", msg.value)
        );
        withdraw();
        return (success, data);
    }

    function withdraw() internal returns (bool, bytes memory) {
        (bool success, bytes memory data) = address(WuraToken).call(
            abi.encodeWithSignature("withdrawEther", msg.sender)
        );
        return (success, data);
    }

    function stake(uint amount) external isTokenHolder {
        //  address(ERC20StandardToken).call(abi.encodeWithSignature("approve(address,uint)", address(this), amount));
        require(amount > 0, "Staking Amount must be greater than zero(0)");
        _transferFrom(amount);
    }

    function _transferFrom(
        uint amount
    ) internal returns (bool success, bytes memory data) {
        Staker storage _staker = stakedBalance[msg.sender];
        WuraToken.transferFrom(msg.sender, address(this), amount);

        //if this is a first stake, set timestamp
        if (_staker.stakedAmount == 0) {
            _staker.firstStakedTime = block.timestamp;
        }

        //if the stake is higher than 1000 WURA tokens, add 5 tokens to staker
        if (_staker.stakedAmount >= HugeStakedValue) {
            _staker.stakedAmount += (amount + 5);
            _staker.hugeStakedValueTimes++;
            _staker.hugeStakedValue = true;
        }
        //if the stake is higher than 1000 WURA tokens, add 5 tokens to staker
        else {
            _staker.stakedAmount += amount;
        }
        calculateAccuredReward();
        return (success, data);
    }

    function calculateAccuredReward() internal returns (bool accured) {}
}
