// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract TimeLock {

    address public admin;

    uint public executeTime;

    uint public expireTime;

    constructor(uint _delay,uint _expire) payable {
        admin = msg.sender;
        executeTime = getBlockTime() + _delay;
        expireTime = getBlockTime() + _expire;
    }

    modifier onlyAdmin {
        require(msg.sender == admin,"must be admin");
        _;
    }

    receive() external  payable {}

    function getBlockTime() public view  returns(uint){
        return block.timestamp;
    }

    function transfer(address payable _to) public onlyAdmin {
        require(getBlockTime() >= executeTime,"must be wait");
        require(getBlockTime() < expireTime,"already expired");
        (bool success,) = _to.call{value : 3 ether}("");
        require(success);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

}