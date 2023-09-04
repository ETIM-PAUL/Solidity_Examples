// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface ERC20Token {
    function balanceOf(address account) external returns (uint);

    function transferFrom(
        address _from,
        address _to,
        uint amount
    ) external returns (bool);

    function transfer(address to, uint amount) external returns (bool);
}

contract StakeTokens {
    ERC20Token WuraToken =
        ERC20Token(0x8Bc4b37aff83FdA8a74d2b5732437037B801183e);
    ERC20Token BigJoeToken =
        ERC20Token(0xdA8a9e85bfd2EEA4750fc2bFd27d5D5f78cfe1FF);
    struct Staker {
        uint stakedAmount;
        uint stakedTime;
        uint totalReward;
    }
    mapping(address => Staker) stakedBalance;
    uint private constant SecondsInOneHour = 3600;

    event TokenStaked(address staker, uint amount);
    event RewardClaimed(address staker, uint amount);

    modifier isTokenHolder() {
        uint wuraTokenBalance = WuraToken.balanceOf(msg.sender);
        require(wuraTokenBalance > 0, "You don't have Wura Tokens");
        _;
    }

    function getStakedDetails(
        address staker
    ) public returns (Staker memory _staker) {
        calculateAccuredReward();
        _staker = stakedBalance[staker];
    }

    function stake(uint amount) external isTokenHolder {
        Staker storage _staker = stakedBalance[msg.sender];

        require(amount > 0, "Staking Amount must be greater than zero(0)");

        bool success = _transferFrom(amount);

        if (success) {
            //if this is a first stake, set timestamp
            if (_staker.stakedAmount == 0) {
                _staker.stakedTime = block.timestamp;
                _staker.stakedAmount = amount;
            } else {
                _staker.stakedAmount += amount;
                //calcaulate accured reward
                calculateAccuredReward();
            }

            emit TokenStaked(msg.sender, amount);
        } else {
            revert("Staking Failed");
        }
    }

    //pays ur rewards in BigJoe Tokens
    function claimReward() external returns (bool success) {
        Staker storage _staker = stakedBalance[msg.sender];
        require(
            _staker.totalReward < BigJoeToken.balanceOf(address(this)),
            "Try Again Later"
        );

        //calculate Accured Rewards
        calculateAccuredReward();
        require(_staker.totalReward > 0, "No Reward");

        BigJoeToken.transfer(msg.sender, _staker.totalReward);
        WuraToken.transfer(msg.sender, _staker.stakedAmount);
        _staker.totalReward = 0;
        _staker.stakedAmount = 0;
        _staker.stakedTime = 0;
        emit RewardClaimed(msg.sender, _staker.totalReward);
        return success = true;
    }

    function _transferFrom(uint amount) internal returns (bool success) {
        success = WuraToken.transferFrom(msg.sender, address(this), amount);
        return (success);
    }

    function calculateAccuredReward() internal {
        Staker storage _staker = stakedBalance[msg.sender];
        uint difference = block.timestamp - _staker.stakedTime;

        //formula to calculate your reward of 10% of staked token and then returns the percent in reward tokens after one week
        _staker.totalReward =
            (difference * _staker.stakedAmount * 10) /
            (SecondsInOneHour * 100);
    }
}
