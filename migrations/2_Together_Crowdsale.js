var TogetherCrowdsale = artifacts.require("./TogetherCrowdsale.sol");
var TogetherToken = artifacts.require("./TogetherToken.sol");

// during testing this migration USE TO require line 44 of zeppelin-solidity/contracts/crowdsale/Crowdsale.sol to be remarked out
// require(_startTime >= now); to enable us to back date the start time. With the zeppelin-solidity 1.7.0 this apparently is no longer the case

// For 1.7.0 oz this also requires the token to be deployed first and the address past in to the Crowdsale constructor

module.exports = function (deployer, network, accounts) {
    const startTime = web3.eth.getBlock('latest').timestamp + 60; // 1 min in the future
    const endTime = startTime + 86400 * 20; // 20 days
    const rate = new web3.BigNumber(2000); // TIG!!!!
    const wallet = accounts[9];
    const goal = new web3.BigNumber(4000000000000000000000); // in wie but 4000 ETH ($2m @ ETH/$500 )
    const cap = new web3.BigNumber(50000000000000000000000); // in wie but 50000 ETH ( $25m @ ETH/$500 )

    deployer.deploy(TogetherCrowdsale,
        rate,
        wallet,
        cap
    );

};

