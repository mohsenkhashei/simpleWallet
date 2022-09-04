// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Allowance {
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

    function addAllowance(address _who, uint256 _amount) public {
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint256 _amount) internal {
        allowance[_who] -= _amount;
    }
}

contract SimpleWallet is Allowance {
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
        _to.transfer(_amount);
    }

    uint256 public balance;

    function getbalance() public {
        balance = address(this).balance;
    }

    receive() external payable {}

    fallback() external payable {}
}
