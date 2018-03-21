pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


import "./TogetherToken.sol";

contract TogetherCrowdsale is CappedCrowdsale, MintedCrowdsale, Ownable {


    // TogetherToken
    // =============

    TogetherToken _token = new TogetherToken();

    // ICO Stage
    // =========

    enum CrowdsaleStage {PreICO, ICO}

    // By default it's Pre Sale
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;

    // =========

    // Amount that was raised in PreICO
    // =======================
    uint256 public totalWeiRaisedDuringPreICO;
    // =======================


    uint256 private _ico_rate;


    // Token Distribution
    // =============================

    uint256 public maxTokens = 200000000000000000000000000; // There will be total 200,000,000 TOG
    uint256 public tokensForEcosystem = 30000000000000000000000000; // 15% TOG
    uint256 public tokensForTeam = 12000000000000000000000000; // 6% TOG
    uint256 public tokensForBounty = 8000000000000000000000000; // 4% TOG (ICO assistance)
    uint256 public totalTokensForSale = 70000000000000000000000000; // 70m TOG will be sold in Crowdsale
    uint256 public totalTokensForSaleDuringPreICO = 80000000000000000000000000; // 80m TOG will be sold during PreICO
    // ==============================

    /**
    * Event for pre ico bonus rate set logging
    * @param rate amount of tokens per wei during pre ico bonus period
    */
    event PreICOBonusRate(uint256 indexed rate);

    /**
    * Event for ico standard bonus rate set logging
    * @param rate amount of tokens per wei during ico period
    */
    event ICOStandardRate(uint256 indexed rate);

    // ============
    // Constructor
    // ============
    function TogetherCrowdsale(uint256 _rate, address _wallet, uint256 _cap) public

    Crowdsale(_rate, _wallet, _token)
    CappedCrowdsale(_cap)

    {}


    /**
    * @dev Crowdsale Stage Management. Change Crowdsale Stage. Available Options: PreICO, ICO. This logic needs thinking about!!!
    * @param value 0 or 1, Pre-ICO and ICO respectively
    */
    function setCrowdsaleStage(uint value) public onlyOwner {

        CrowdsaleStage _stage;

        // todo: require needed for stage to be an acceptable value (although only impact owner)

        if (uint(CrowdsaleStage.PreICO) == value) {
            _stage = CrowdsaleStage.PreICO;
        } else if (uint(CrowdsaleStage.ICO) == value) {
            _stage = CrowdsaleStage.ICO;
        }

        stage = _stage;

        if (stage == CrowdsaleStage.PreICO) {
            _ico_rate = rate;
            rate = rate.mul(13).div(10);

            PreICOBonusRate(rate);

        } else if (stage == CrowdsaleStage.ICO) {
            rate = _ico_rate;
            ICOStandardRate(rate);
            /*
            * todo: if we assume switching to ICO is once, we could record the amount raised in the Pre ICO like this...
            * but maybe not the final solution!
            */
            totalWeiRaisedDuringPreICO = weiRaised;
        }
    }


}