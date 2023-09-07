// SPDX-License-Identifier: MIT

pragma solidity 0.8.21;

interface ERC20Token {
    function transferFrom(
        address _from,
        address _to,
        uint amount
    ) external returns (bool);

    function transfer(address to, uint amount) external returns (bool);
}

contract SwapTokens {
    ERC20Token TokenA = ERC20Token(0x8Bc4b37aff83FdA8a74d2b5732437037B801183e);
    ERC20Token TokenB = ERC20Token(0xdA8a9e85bfd2EEA4750fc2bFd27d5D5f78cfe1FF);

    event TokensSwapped();

    function swapTokenAforB(uint amount) external returns (bool _success) {
        require(amount > 0, "Zero Amount");
        bool success = TokenA.transferFrom(msg.sender, address(this), amount);
        require(success, "Swapping failed");

        bool successSecond = TokenB.transfer(msg.sender, amount * 2);
        require(successSecond, "Swapping failed");

        _success = true;

        if (_success) {
            emit TokensSwapped();
        } else {
            revert();
        }
    }

    function swapTokenBforA(uint amount) external returns (bool _success) {
        require(amount > 0, "Zero Amount");
        bool success = TokenB.transferFrom(msg.sender, address(this), amount);
        require(success, "Swapping failed");

        //give the account 50% of tokenB, which is basically half of the tokenB
        bool successSecond = TokenA.transfer(
            msg.sender,
            ((amount * 500) / 1000)
        );
        require(successSecond, "Swapping failed");

        _success = true;

        if (_success) {
            emit TokensSwapped();
        } else {
            revert();
        }
    }
}
