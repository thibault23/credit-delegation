//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import './interfaces/IProtocolDataProvider.sol';
import './interfaces/IDebtToken.sol';

/*
    The most simplified version will be transferring one token type to the credit pool,
    delegating credit in one token type currency to a margin pool,
    from which one user can tap into and use to invest into one yield farming opportunity.
    The user will be able to monitor her position.
*/

contract CreditPool {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public delegatedAmounts;
    uint256 public totalDelegated;

    //debt token
    address constant dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    //address constant marginPool = "";
    IProtocolDataProvider constant provider = IProtocolDataProvider(address(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d));


    function deposit(address aToken, uint256 amount, address token, address marginPool) external {
        require(IERC20(aToken).balanceOf(msg.sender) != 0, "sender doesn't have any deposit on Aave");
        balances[msg.sender] += amount;
        IERC20(aToken).safeTransferFrom(msg.sender, address(this), amount);
        increaseDelegation(amount, token, marginPool);
    }

    function increaseDelegation(uint256 amount, address token, address marginPool) public {
        totalDelegated += amount;
        (, , address variableDebtTokenAddress) = provider.getReserveTokensAddresses(token);
        IDebtToken(variableDebtTokenAddress).approveDelegation(marginPool, amount);
    } 
}