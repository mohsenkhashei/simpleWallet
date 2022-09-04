// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Allowance.sol";

contract SimpleWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint256 _amount);
    event MoneyReceived(address indexed _from, uint256 _amount);

    /**
     * withdraw money only owner or in whose in allowance
     * @address address of withdraw money to
     * @_amount the amount
     */
    function withdrawMoney(address payable _to, uint256 _amount)
        public
        onlyOwnerOrAllowed(_amount)
    {
        require(
            _amount <= address(this).balance,
            "there are not enough stored in the smart contract"
        );
        if (_checkOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    fallback() external payable {}
}
