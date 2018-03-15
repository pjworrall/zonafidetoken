pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';
import "zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";


contract TogetherCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {


    // ICO Stage
    // ============

    enum CrowdsaleStage { PreICO, ICO }

    // By default it's Pre Sale
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;

    // ============

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


    // Crowdsale Stage Management
    // =========================================================
    // Change Crowdsale Stage. Available Options: PreICO, ICO
    function setCrowdsaleStage(uint value) public onlyOwner {

        CrowdsaleStage _stage;

        if (uint(CrowdsaleStage.PreICO) == value) {
            _stage = CrowdsaleStage.PreICO;
        } else if (uint(CrowdsaleStage.ICO) == value) {
            _stage = CrowdsaleStage.ICO;
        }

        stage = _stage;

        if (stage == CrowdsaleStage.PreICO) {
            setCurrentRate(2);   // this is a 100% we will need a 30% bonus
        } else if (stage == CrowdsaleStage.ICO) {
            setCurrentRate(1);   // no bonus in the public sale
        }
    }

    // Change the current rate
    // @todo: would we want to be able to do this?
    function setCurrentRate(uint256 _rate) private {
        rate = _rate;
    }

}