pragma solidity 0.4.24;

contract SimpleCounter {
    int counter; // state variable
    address owner;

    constructor() public {
        counter = 0;
        owner = msg.sender;
    }

    function getCounter() view public returns(int) {
        return counter;
    }

    function increment() public {
        counter += 1;
    }

    function decrement() public {
        counter -= 1;
    }

    function reset() public {
        require(msg.sender == owner);
        counter = 0;
    }
}