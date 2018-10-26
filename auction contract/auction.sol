pragma solidity ^0.4.24;

interface Auction {
    function bid() external payable;
    function end() external;
}