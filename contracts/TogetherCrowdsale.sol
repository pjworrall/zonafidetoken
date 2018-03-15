pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';
import "zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";


contract TogetherCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {

    // Constructor
    // migrated behaviour to new zeppelin-solidity 1.7.0
    // ============
    function TogetherCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap, MintableToken _token) public

    Crowdsale(_rate, _wallet, _token)
    CappedCrowdsale(_cap)
    TimedCrowdsale(_startTime, _endTime)
    RefundableCrowdsale(_goal)

    {
        require(_goal <= _cap);
    }

}