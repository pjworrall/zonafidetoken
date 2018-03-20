pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


import "./TogetherToken.sol";

contract TogetherCrowdsale is  CappedCrowdsale, MintedCrowdsale, Ownable {


    // TogetherToken

    TogetherToken _token = new TogetherToken();

    // ICO Stage
    // ============

    enum CrowdsaleStage { PreICO, ICO }

    // By default it's Pre Sale
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;


    // Token Distribution
    // =============================

    uint256 public maxTokens = 200000000000000000000000000; // There will be total 200,000,000 TOG
    uint256 public tokensForEcosystem = 30000000000000000000000000; // 15% TOG
    uint256 public tokensForTeam = 12000000000000000000000000; // 6% TOG
    uint256 public tokensForBounty = 8000000000000000000000000; // 4% TOG (ICO assistance)
    uint256 public totalTokensForSale = 70000000000000000000000000; // 70m TOG will be sold in Crowdsale
    uint256 public totalTokensForSaleDuringPreICO = 80000000000000000000000000; // 80m TOG will be sold during PreICO
    // ==============================



    // ============
    // Constructor
    // ============
    function TogetherCrowdsale(uint256 _rate, address _wallet, uint256 _cap) public

    Crowdsale(_rate, _wallet, _token)
    CappedCrowdsale(_cap)

    {}

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
            rate = rate;   // this is where a 30% bonus
        } else if (stage == CrowdsaleStage.ICO) {
            rate = rate;   // no bonus in the public sale
        }
    }


}