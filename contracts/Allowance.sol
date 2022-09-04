// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance {
    using SafeMath for uint256;

    event AllowanceChanged(
        address indexed _forWho,
        address indexed _fromWhom,
        uint256 _oldAmount,
        uint256 _newAmount
    );

    address private owner;
    constructor() {
        owner = msg.sender;
    }

    function _checkOwner() internal view returns (bool) {
        if (owner == msg.sender) {
            return true;
        } else {
            return false;
        }
    }

    modifier onlyOwnerOrAllowed(uint256 _amount) {
        require(
            _checkOwner() || allowance[msg.sender] >= _amount,
            "you are not allowed"
        );
        _;
    }

    mapping(address => uint256) public allowance;
    /**
     * adding address and amount to allow list
     * @address address allowed
     * @_amount amount allowed
     */
    function addAllowance(address _who, uint256 _amount) public {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    /**
     * reducing amount after they withdraw money
     * @address address 
     * @_amount amount 
     */
    function reduceAllowance(address _who, uint256 _amount) internal {
        emit AllowanceChanged(
            _who,
            msg.sender,
            allowance[_who],
            allowance[_who].sub(_amount)
        );
        allowance[_who] = allowance[_who].sub(_amount);
    }
}
