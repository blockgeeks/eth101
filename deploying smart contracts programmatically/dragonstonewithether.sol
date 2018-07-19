pragma solidity ^0.4.0;

/*
Currency that can only be issued by its creator and transferred to anyone
*/
contract DragonStone {
    address public creator;
    mapping (address => uint) public balances;
    uint public PRICE = 3000000000000000000;//3 ether

    // event that notifies when a transfer has completed
    event Delivered(address from, address to, uint amount);

    function DragonStone() {
        creator = msg.sender;
    }

    function create() payable {
        require(msg.value > 0 && msg.value % PRICE == 0);
        balances[msg.sender] += (msg.value / PRICE);
    }

    function transfer(address receiver, uint amount) {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Delivered(msg.sender, receiver, amount);
    }
}