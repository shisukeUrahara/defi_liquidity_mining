pragma solidity ^0.7.3;

import './GovernanceToken.sol';
import './LpToken.sol';
import './UnderlyingToken.sol';

contract LiquidityPool is LpToken{
    // mapping to keep track of governance tokens
    mapping(address => uint) public checkpoints;
    // references of other tokens
    GovernanceToken public governanceToken;
    UnderlyingToken public underlyingToken;
    // reward per block i.e user will get this much
    // governance token as reward for each underlying token invested
    uint constant public REWARD_PER_BLOCK=1;


    // constructor to instantiate governance token and underlying token contracts
    constructor (address _underlyingToken , address _governanceToken){
        underlyingToken= UnderlyingToken(_underlyingToken);
        governanceToken= GovernanceToken(_governanceToken);

    }

    // a deposit function to let users provide liquidity 
    function deposit (uint amount) external {

        // check at what point is user providing liquidity 
        if(checkpoints[msg.sender]==0){
           checkpoints[msg.sender]=block.number;
        }

     // distribute rewards if this is not user's first deposit
     _distributeRewards(msg.sender);   
     // send user's underlying token to the contract
     underlyingToken.transferFrom(msg.sender,address(this),amount);

     // give lp token as reward to the sender
     _mint(msg.sender,amount);

    }

    // a function to withdraw lptoken and get underlying token back 
    function withdraw (uint amount) external {
        // check that user has enough lp token to withdraw
        require(balanceOf(msg.sender)>= amount ,'LP token balance too low');
        // distribute rewards
             _distributeRewards(msg.sender);   

        // send underlying token back to the user
        underlyingToken.transfer(msg.sender,amount);

    //   burn the lp tokens
        _burn(msg.sender,amount)
    }

    function _distributeRewards(address beneficiary) internal {
        uint checkpoint = checkpoints[beneficiary];

        // check that user is  not rewarded twice for the same block
        if(block.number - checkpoint >0){
            // in this example , user invest 1 underlying token and gets 1 lp token  
            uint distributionAmount = balanceOf(beneficiary) * (block.number - checkpoint) *REWARD_PER_BLOCK;
            // mint and send governance token with distributionAmount to the provider
            governanceToken.mint(beneficiary,amount);
            checkpoints[msg.sender]=block.number;
        }
    }
}