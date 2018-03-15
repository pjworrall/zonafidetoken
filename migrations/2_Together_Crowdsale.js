var TogetherCrowdsale = artifacts.require("./TogetherCrowdsale.sol");
var TogetherToken = artifacts.require("./TogetherToken.sol");

// during testing this migration USE TO require line 44 of zeppelin-solidity/contracts/crowdsale/Crowdsale.sol to be remarked out
// require(_startTime >= now); to enable us to back date the start time. With the zeppelin-solidity 1.7.0 this apparently is no longer the case

// For 1.7.0 oz this also requires the token to be deployed first and the address past in to the Crowdsale constructor

module.exports = function (deployer, network, accounts) {
    const startTime = web3.eth.getBlock('latest').timestamp + 60; // 1 min in the future
    const endTime = startTime + 86400 * 20; // 20 days
    const rate = new web3.BigNumber(1000);
    const wallet = accounts[9];

    const goal = new web3.BigNumber(200000000000000000000);
    const cap = new web3.BigNumber(25000000000000000000000000);

    return deployer
        .then(() => {
            return deployer.deploy(TogetherToken);
        })
        .then(() => {
            return deployer.deploy(
                TogetherCrowdsale,
                startTime,
                endTime,
                rate,
                wallet,
                goal,
                cap,
                TogetherToken.address
            );
        });
};

