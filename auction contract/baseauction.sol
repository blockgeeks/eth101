pragma solidity ^0.4.24;

contract BaseAuction {

    address public owner;

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    event AuctionComplete(address winner, uint bid);
    event BidAccepted(address bidder, uint bid);

    constructor() public {
        owner = msg.sender;
    }

    function bid() external payable;
    function end() external;
}