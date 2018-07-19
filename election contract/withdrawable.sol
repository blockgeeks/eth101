pragma solidity ^0.4.0;


contract Withdrawable {
    
    mapping(address => uint) internal pendingWithdrawals;
    
    function withdraw() public returns (bool) {
        uint amount = pendingWithdrawals[msg.sender];
        if(amount > 0) {
            //update state before interacting with external address
            pendingWithdrawals[msg.sender] = 0;
            //using send() returns a boolean, check to see if transfer is successful
            if (!msg.sender.send(amount)) {
                //if not successful, then set back original amount
                pendingWithdrawals[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
}