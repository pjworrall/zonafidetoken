pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';
import "zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";


// ================

// As we get more familiar with OpenZeppelin we MUST make sure Tokens cannot
// be transferred until the crowdsale is over.

// ================


contract TogetherToken is MintableToken {
    string public name = "Together Token";
    string public symbol = "TOG";
    uint8 public decimals = 18; // this is the recommended decimals
}


contract TogetherCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {

    // ICO Stage
    // ============
    enum CrowdsaleStage {PreICO, ICO}
    CrowdsaleStage public stage = CrowdsaleStage.PreICO; // By default it's Pre Sale
    // =============

    // Token Distribution
    // =============================
    uint256 public maxTokens = 200000000000000000000000000; // There will be total 200,000,000 TOG
    uint256 public tokensForEcosystem = 30000000000000000000000000; // 15% TOG
    uint256 public tokensForTeam = 12000000000000000000000000; // 6% TOG
    uint256 public tokensForBounty = 8000000000000000000000000; // 4% TOG (ICO assistance)
    uint256 public totalTokensForSale = 70000000000000000000000000; // 70m TOG will be sold in Crowdsale
    uint256 public totalTokensForSaleDuringPreICO = 80000000000000000000000000; // 80m TOG will be sold during PreICO
    // ==============================

    // Amount raised in PreICO
    // ==================
    uint256 public totalWeiRaisedDuringPreICO;
    // ===================


    // Events
    event EthTransferred(string text);
    event EthRefunded(string text);


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
    // =============

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
            rate = 2;  // this is a 100% we will need a 30% bonus
        } else if (stage == CrowdsaleStage.ICO) {
            rate = 1 ; // no bonus in the public sale
        }
    }

    // ================ Stage Management Over =====================

    // Token Purchase
    // =========================
    function() external payable {
        uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
        if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
            msg.sender.transfer(msg.value);
            // Refund them
            EthRefunded("PreICO Limit Hit");
            return;
        }

        buyTokens(msg.sender);

        if (stage == CrowdsaleStage.PreICO) {
            totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
        }
    }

    // overriding the _forwardFunds() on the RefundableCrowdsale
    // but I don't quite know whether/how it does not pickup the one on Crowdsale

    function _forwardFunds() internal {
        if (stage == CrowdsaleStage.PreICO) {
            wallet.transfer(msg.value);
            EthTransferred("forwarding funds to wallet");
        } else if (stage == CrowdsaleStage.ICO) {
            EthTransferred("forwarding funds to refundable vault");
            super._forwardFunds();  // the super appears to pick up RefundableCrowdsale
        }
    }
    // ===========================

    // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.

    // We'll be probably burning in here because this example mints the full amount
    // We would be probably making the team, ecosystem and bounty allocations before the pre-sale


    // this function is not implement on examples so not sure how this relates to the orchestration

    // ====================================================================

    function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {

        require(!isFinalized);
        uint256 alreadyMinted = token.totalSupply();
        require(alreadyMinted < maxTokens);

        uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
        if (unsoldTokens > 0) {
            tokensForEcosystem = tokensForEcosystem + unsoldTokens;
        }

        token.mint(_teamFund, tokensForTeam);
        token.mint(_ecosystemFund, tokensForEcosystem);
        token.mint(_bountyFund, tokensForBounty);
        finalize();
    }
    // ===============================

    // REMOVE THIS FUNCTION ONCE YOU ARE READY FOR PRODUCTION
    // USEFUL FOR TESTING `finish()` FUNCTION
    // it is overriding the function on super
    function hasEnded() public view returns (bool) {
        return true;
    }
}