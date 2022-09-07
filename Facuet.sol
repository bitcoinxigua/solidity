// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Facuet {

    event Receive(address indexed caller,uint value);

    receive() external payable {
        emit Receive(msg.sender,msg.value);
    }

    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner,"must be owner");
        _;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deleteContract() external onlyOwner {
        selfdestruct(payable(owner));
    }

    function getEth() external {
        require(address(this).balance > 1 ether,"not enough eth");
        uint time = receiveTime[msg.sender];
        require(time == 0 || getBlockTime() > time + ONE_DAY,"must be separated by a day");
        (bool success,) = msg.sender.call{value : 1 ether}("");
        require(success,"Failed to get faucet");
        receiveTime[msg.sender] = getBlockTime();
    }

    mapping (address => uint) public receiveTime;

    // uint constant ONE_DAY = 86400;
    uint constant ONE_DAY = 30;

    function getBlockTime() public view returns(uint) {
        return block.timestamp;
    }


}