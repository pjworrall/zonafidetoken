pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract TogetherToken is MintableToken {
  string public name = "Together Token";
  string public symbol = "TOG";
  uint8 public decimals = 18; // this is the recommended decimals
}
