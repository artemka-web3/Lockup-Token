// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LockupPool {
    event Withdraw(address indexed _withdrawalAccount, uint indexed _withdrawAmount, uint indexed _amountLeft);
    event Deposit(address indexed _depoitor, uint indexed _depositedAmount);


    uint public lockupTime;
    uint public lockupDeadline;
    uint public tokenAmount;
    ERC20 public lockedToken;
    address poolOwner;

    constructor(address _owner, uint _lockupTime, uint _tokenAmount, address _token) {
        lockupTime = _lockupTime;
        lockupDeadline = block.timestamp + _lockupTime;

        tokenAmount = _tokenAmount;
        lockedToken = ERC20(_token);

        poolOwner = _owner;


        //lockedToken.transferFrom(poolOwner, address(this), _tokenAmount);
        //emit Deposit(poolOwner, _tokenAmount);
    }
    function deposit(uint _depositAmount) external onlyOwner{
        tokenAmount += _depositAmount;
        lockedToken.transferFrom(msg.sender, address(this), _depositAmount);
        emit Deposit(msg.sender, _depositAmount);
    }

    function withdraw(uint _withdrawAmount) external onlyOwner {
        require(tokenAmount >= _withdrawAmount, "Not enough to withdraw!");
        require(block.timestamp >= lockupDeadline, "You need to wait before deadline!");
        tokenAmount -= _withdrawAmount;
        lockedToken.transferFrom(address(this), msg.sender, _withdrawAmount);
        emit Withdraw(msg.sender, _withdrawAmount, tokenAmount);
    }

    function getPoolBalance() public view returns(uint) {
        return tokenAmount;
    }

    function getLockupDeadline() public view returns(uint){
        return lockupDeadline;
    }

    function getLockupPeriod() public view returns(uint){
        return lockupTime;
    }

    modifier onlyOwner() {
        require(msg.sender == poolOwner, "Only owner is allowed to perform this action");
        _;
    }


}
