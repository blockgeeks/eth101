pragma solidity ^0.4.0;

/*
Simple wallet contract that allows the single owner to withdraw and deposit ether
*/
contract SimpleWallet {
    
    address public owner;
    
    modifier ownerOnly() {
        if(msg.sender != owner) revert();
        _;
    }
    
    function SimpleWallet() {
        owner = msg.sender;
    }
    
    function getBalance() constant returns (uint) {
        return this.balance;
    }
    
    function withdraw(uint amount) ownerOnly {
        if(amount > this.balance) revert();
        
        owner.transfer(amount);
    }
    
    function deposit() ownerOnly payable {
        //amount of ether sent in msg.value is added to wallet
    }
}