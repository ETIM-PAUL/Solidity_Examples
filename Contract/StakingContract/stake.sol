// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

interface ERC20Token {
    function balanceOf(address account) external returns (uint);

    function transferFrom(
        address _from,
        address _to,
        uint amount
    ) external returns (bool);

    function buyToken() external returns (uint);

    function approve(address spender, uint256 amount) external;

    function transfer(address to, uint amount) external returns (bool);
}

interface ERC20TokenReward {
    function balanceOf(address account) external returns (uint);

    function transfer(address to, uint amount) external returns (bool);
}

contract StakeTokens {
    ERC20Token WuraToken;
    ERC20TokenReward BigJoeToken;
    struct Staker {
        uint stakedAmount;
        uint stakedTime;
        uint totalReward;
        uint hugeStakedValueTimes;
        bool hugeStakedValue;
    }
    mapping(address => Staker) stakedBalance;
    uint private constant HugeStakedValue = 1000;
    uint private constant SecondsInMonth = 18_748_800;

    event TokenStaked(address staker, uint amount);
    event RewardClaimed(address staker, uint amount);

    constructor() {
        WuraToken = ERC20Token(0x8Bc4b37aff83FdA8a74d2b5732437037B801183e);
        BigJoeToken = ERC20TokenReward(
            0x8Bc4b37aff83FdA8a74d2b5732437037B801183e
        );
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
        Staker storage _staker = stakedBalance[msg.sender];

        require(amount > 0, "Staking Amount must be greater than zero(0)");

        (bool success, ) = _transferFrom(amount);

        if (success) {
            //if this is a first stake, set timestamp
            if (_staker.stakedAmount == 0) {
                _staker.stakedTime = block.timestamp;
                _staker.stakedAmount = amount;
            } else {
                //if the stake is higher than 1000 WURA tokens and its not first staking, increase hughStakedTimes
                if (amount >= HugeStakedValue && _staker.stakedAmount != 0) {
                    _staker.hugeStakedValueTimes++;
                    _staker.hugeStakedValue = true;
                    _staker.stakedAmount += amount;
                } else {
                    _staker.stakedAmount += amount;
                }

                //calcaulate accured reward
                calculateAccuredReward();
            }

            emit TokenStaked(msg.sender, amount);
        } else {
            revert("Staking Failed");
        }
    }

    //pays ur rewards in BigJoe Tokens
    function withdrawStaked(uint amount) external returns (bool success) {
        require(amount > 0, "Value must be greater than Zero");
        Staker storage _staker = stakedBalance[msg.sender];
        require(_staker.stakedAmount >= amount, "Insufficient funds");
        _staker.stakedAmount -= amount;
        WuraToken.transfer(msg.sender, amount);

        //calculate Accured Rewards
        calculateAccuredReward();
        return success = true;
    }

    //pays ur rewards in BigJoe Tokens
    function claimReward(uint amount) external returns (bool success) {
        require(amount > 0, "Value must be greater than Zero");
        require(
            BigJoeToken.balanceOf(address(this)) >= amount,
            "Please Try Later"
        );

        //calculate Accured Rewards
        calculateAccuredReward();
        Staker storage _staker = stakedBalance[msg.sender];
        require(_staker.totalReward >= amount, "Insufficient Reward");
        _staker.totalReward -= amount;
        BigJoeToken.transfer(msg.sender, amount);
        return success = true;
    }

    function _transferFrom(
        uint amount
    ) internal returns (bool success, bytes memory data) {
        WuraToken.transferFrom(msg.sender, address(this), amount);
        return (success, data);
    }

    function calculateAccuredReward() private {
        Staker storage _staker = stakedBalance[msg.sender];
        uint difference = block.timestamp - _staker.stakedTime;
        _staker.totalReward = ((difference * (_staker.stakedAmount) * 50) /
            SecondsInMonth);
        _staker.stakedTime = block.timestamp;
    }
}
