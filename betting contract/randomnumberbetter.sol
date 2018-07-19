pragma solidity ^0.4.18;

import "./withdrawable.sol";

/*
Simple 2-player betting game where both have to guess a random number 
between 1 and 100 inclusive and whoever guesses closest is the winner
*/
contract RandomNumberBetter is Withdrawable {
    
    uint public constant MIN_GUESS = 1;
    uint public constant MAX_GUESS = 100;
    
    enum State {WAGER_OPEN, WAGER_SET, COMPLETE}
    
    State public currentState;
    address public player1;
    address public player2;
    uint public wager;
    mapping(address => uint) guesses;
    uint public minWager;
    uint public maxWager;
    bytes32 seedHash;
    
    modifier playersOnly() {
        require(msg.sender == player1 || msg.sender == player2);
        _;
    }
    
    modifier inState(State expectedState) {
        require(currentState == expectedState);
        _;
    }
    
    event StatusUpdate(string update);
    event GeneratedRandomNumber(uint number);
    
    function RandomNumberBetter(address _player1, address _player2,
                                uint _minWager, uint _maxWager) public {
        require(_minWager < _maxWager);
        player1 = _player1;
        player2 = _player2;
        minWager = _minWager;
        maxWager = _maxWager;
        seedHash = block.blockhash(block.number-1);
        StatusUpdate("wager open");
    }
    
    function submitWager(uint guess) public playersOnly inState(State.WAGER_OPEN) payable {
        //make sure the guess is valid
        require(guess >= MIN_GUESS && guess <= MAX_GUESS);
        //make sure wager is valid
        require(msg.value >= minWager && msg.value <= maxWager);
        
        //if no wagers have been made yet
        if(wager == 0){
            //set the first player's wager
            wager = msg.value;
            guesses[msg.sender] = guess;
            StatusUpdate("wager accepted");
            return;
        }
        
        //wager must match what was waged by first player
        require(msg.value == wager);
        //make sure its the second player that is matching wager
        require(guesses[msg.sender] == 0);
        
        guesses[msg.sender] = guess;
        currentState = State.WAGER_SET;
        StatusUpdate("wager set”);
    }
    
    function resolveWager() public playersOnly inState(State.WAGER_SET) {
        //generate random number between 1 and 100
        uint randomNumber = (rand() % MAX_GUESS)+1;//plus 1 because mod will return 0-99
        GeneratedRandomNumber(randomNumber);
        
        //calculate absolute difference between player guesses and random number
        int player1Diff = int(randomNumber - guesses[player1]);
        int player2Diff = int(randomNumber - guesses[player2]);
        if (player1Diff < 0) player1Diff *= -1;
        if (player2Diff < 0) player2Diff *= -1;
        
        //if game is a draw, return back bets
        if(player1Diff == player2Diff){
            pendingWithdrawals[player1] = this.balance/2;
            pendingWithdrawals[player2] = this.balance/2;
            StatusUpdate("game draw");
        }//if player1 won
        else if (player1Diff < player2Diff){
            pendingWithdrawals[player1] = this.balance;
            StatusUpdate("player1 wins");
        }//if player2 won
        else {
            pendingWithdrawals[player2] = this.balance;
            StatusUpdate("player2 wins");
        }
        currentState = State.COMPLETE;
    }
    
    function rand() private returns (uint) {
        uint seedInt = uint(seedHash)/2;//divide by 2 to prevent overflow when adding salt
        seedInt += now;//add timestamp as salt
        return uint(sha256(seedInt));
    }   
}