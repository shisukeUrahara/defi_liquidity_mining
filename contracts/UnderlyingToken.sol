pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract UnderlyingToken {
    // constructor 
    constructor () ERC20 ('Underlying Token','UTK'){}

    // a faucte function for testing purpose
    function faucet(address _to, uint _amount) external {
        _mint(to,amount);
    }
}