// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract NumModify {

    uint public num = 0;

    function set(uint _num) public {
        num = _num;
    }
}

contract CallContract {

    function callTest(address _contractAddr,uint _num) external returns(bool){
        (bool _flag,) = _contractAddr.call(abi.encodeWithSignature("set(uint256)",_num));
        return _flag;
    }

}