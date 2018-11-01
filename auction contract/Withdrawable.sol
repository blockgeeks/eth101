pragma solidity ^0.4.24;

contract Withdrawable {
    mapping(address => uint) internal pendingWithdrawals;

    function withdraw() public returns(bool) {
        uint amount = pendingWithdrawals[msg.sender];
        require(amount > 0);

        pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}