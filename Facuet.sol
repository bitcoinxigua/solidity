// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

//import Open Zepplins ERC-20 interface contract and Ownable contract
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//create a ERC20 faucet contract
// Logic: people can deposit tokens to the faucet contract, and let other users to request some tokens.
contract Faucet is Ownable {

    uint256 public amountAllowed = 100 * 10 ** 18;

    address public tokenContract;

    mapping(address => bool) public requestedAddress;

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    event SendToken(address indexed Receiver,uint256 indexed Amount);
    event WithdrawToken(address indexed sender,address indexed TokenContract,uint256 indexed Amount);
    event WithdrawETH(address indexed sender,uint256 indexed Amount);

    function requestTokens() external {
        require(requestedAddress[_msgSender()] == false,"Can't Request Multiple Times!");
        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this)) >= amountAllowed,"Faucet Empty!");

        token.transfer(_msgSender(),amountAllowed);
        requestedAddress[_msgSender()] = true;
        emit SendToken(_msgSender(),amountAllowed);
    }

    function setAmount (uint256 _amount) external onlyOwner {
        amountAllowed = _amount;
    }

    function withdrawToken(address _tokenContract,uint256 _amount) public onlyOwner {
        IERC20 token = IERC20(_tokenContract);

        token.transfer(_msgSender(),_amount);
        emit WithdrawToken(_msgSender(),_tokenContract,_amount);
    }

    function withdrawETH() public onlyOwner {
        address payable owner = payable(owner());
        uint256 amount = address(this).balance;
        owner.transfer(amount);
        emit WithdrawETH(_msgSender(),amount);
    }


}
