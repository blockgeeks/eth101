pragma solidity ^0.4.24;

import "./BaseAuction.sol";
import "./Withdrawable.sol";

contract TimerAuction is BaseAuction, Withdrawable {
    string public item;
    uint public auctionEnd;
    address public maxBidder;
    uint public maxBid;
    bool public ended;

    constructor(string _item, uint _durationMinutes) public {
        item = _item;
        auctionEnd = now + (_durationMinutes * 1 minutes);
    }

    function bid() external payable {
        require(now < auctionEnd);
        require(msg.value > maxBid);

        if (maxBidder != address(0)) {
            pendingWithdrawals[maxBidder] += maxBid;
        }

        maxBidder = msg.sender;
        maxBid = msg.value;
        emit BidAccepted(maxBidder, maxBid);
    }

    function end() external ownerOnly {
        require(!ended);
        require(now >= auctionEnd);
        ended = true;

        emit AuctionComplete(maxBidder, maxBid);

        owner.transfer(maxBid);
    }
}

