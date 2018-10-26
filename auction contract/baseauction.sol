pragma solidity ^0.4.24;

import "./auction.sol";

contract BaseAuction is Auction {

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
}