// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./LockupPool.sol";


/// @title Lockup Pools Factory
/// @author me
/// @notice This smart contract creates lockup pools
/// @dev This smart contract creates new smart contracts (lockup pools) with create2 opcode
contract LockupPoolsFactory {
     /* 
        //// EVENTS ////
    */
    event CreateLockupPool(address indexed _poolOwner, uint indexed _lockupTime, address indexed _tokenAddress, uint _tokenAmount, uint _lockupDeadline);


    /* 
        //// STRUCTS ////
    */
    struct LockupPoolStruct {
        address poolAddr;
        address poolOwner;
        uint lockupTime;
        address tokenAddress;
        uint tokenAmount;
        uint lockupDeadline;
    }
    mapping(uint => mapping(address => LockupPoolStruct)) public pools;
    address [] poolAdresses;
    uint public poolId;


    function deploy(
        address _owner,
        uint _lockupTime,
        uint _tokenAmount,
        address _token,
        bytes32 _salt
    ) public returns (address) {
        // This syntax is a newer way to invoke create2 without assembly, you just need to pass salt
        // https://docs.soliditylang.org/en/latest/control-structures.html#salted-contract-creations-create2
        uint deadline = block.timestamp + _lockupTime;
        address newPool = address(new LockupPool{salt: _salt}(_owner, _lockupTime, _tokenAmount, _token));
        pools[poolId][newPool] = LockupPoolStruct(newPool, msg.sender, _lockupTime, _token, _tokenAmount, deadline);
        poolId += 1;
        return newPool;

    }

}