var TogetherCrowdsale = artifacts.require("./TogetherCrowdsale.sol");

// during testing this migration requires line 44 of zeppelin-solidity/contracts/crowdsale/Crowdsale.sol remarked out
// require(_startTime >= now); to enable us to back date the start time

module.exports = function(deployer) {
  const startTime = Math.round((new Date(Date.now() - 86400000).getTime())/1000); // Yesterday
  const endTime = Math.round((new Date().getTime() + (86400000 * 20))/1000); // Today + 20 days
  deployer.deploy(TogetherCrowdsale,
    startTime,
    endTime,
    2000, // ETH/TOG rate initially 2000
    "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE", // 10th account from Ganache UI as the beneficiary address.
    200000000000000000000, // soft cap 200  in ETH worked at todo: at ETH/USD rate on what date?
    25000000000000000000000000 // Hard cap 25,000 ETH, eg at USD/ETH $1000
  );
};