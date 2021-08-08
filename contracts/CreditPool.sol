//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import './IProtocolDataProvider.sol';
import './IDebtToken.sol';


contract CreditPool {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public delegatedAmounts;

    //debt token
    address constant dai = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
    address constant marginPool = "";
    IProtocolDataProvider constant provider = IProtocolDataProvider(address(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d));


    function deposit(address aToken, uint256 amount) external {
        require(IERC20(aToken).balanceOf(msg.sender) != 0, "sender doesn't have tokens");
        balances[msg.sender] += amount;
        IERC20(aToken).safeTransferFrom(msg.sender, address(this), amount);
        increaseDelegation(token, amount);
    }

    function increaseDelegation(address aToken, uint256 amount) public {
        delegatedAmounts[msg.sender] += amount;
        (, , address variableDebtTokenAddress) = provider.getReserveTokensAddresses(dai);
        IDebtToken(variableDebtTokenAddress).approveDelegation(marginPool, amount);

    }

    function 
}