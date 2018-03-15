var TogetherCrowdsale = artifacts.require("TogetherCrowdsale");
var TogetherToken = artifacts.require("TogetherToken");
var BigNumber = require('bignumber.js');

// all these test require altering to suit our new parameters

contract('TogetherCrowdsale', function (accounts) {
    it('TEST 1 - should deploy the token and store the address', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            const token = await instance.token.call();
            assert(token, 'Token address couldn\'t be stored');
            done();
        });
    });

    it('TEST 2 - should set stage to PreICO', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            await instance.setCrowdsaleStage(0);
            const stage = await instance.stage.call();
            assert.equal(stage.toNumber(), 0, 'The stage couldn\'t be set to PreICO \n'+stage.toNumber()+' != 0\n');
            done();
        });
    });

    it('TEST 3 - one ETH should buy 2000 Together Tokens in PreICO', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            const data = await instance.sendTransaction({from: accounts[7], value: web3.toWei(1, "ether")});
            const tokenAddress = await instance.token.call();
            const togetherToken = TogetherToken.at(tokenAddress);
            const tokenAmount = await togetherToken.balanceOf(accounts[7]);

            var outputAmount = new BigNumber(tokenAmount);
            var expectedAmount = new BigNumber(2000000000000000000);
            //even though we have converted it to bigNumber in order to do a equality check we have to cast the big number back to a number
            outputAmount = outputAmount.toNumber();
            expectedAmount = expectedAmount.toNumber();

            assert.equal(outputAmount, expectedAmount, 'The sender didn\'t receive the tokens as per PreICO rate \n'+outputAmount+' != '+expectedAmount+'\n');
            done();
        });
    });

    it('TEST 4 - should transfer the ETH to wallet immediately in Pre ICO', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            let balanceOfBeneficiary = await web3.eth.getBalance(accounts[9]);
            balanceOfBeneficiary = Number(balanceOfBeneficiary.toString(10));

            await instance.sendTransaction({from: accounts[1], value: web3.toWei(2, "ether")});

            let newBalanceOfBeneficiary = await web3.eth.getBalance(accounts[9]);
            newBalanceOfBeneficiary = Number(newBalanceOfBeneficiary.toString(10));

            var outputAmount = new BigNumber(newBalanceOfBeneficiary);
            var expectedAmount = new BigNumber(balanceOfBeneficiary + 2000000000000000000);
            //even though we have converted it to bigNumber in order to do a equality check we have to cast the big number back to a number
            outputAmount = outputAmount.toNumber();
            expectedAmount = expectedAmount.toNumber();

            assert.equal(outputAmount, expectedAmount, 'ETH couldn\'t be transferred to the beneficiary \n'+outputAmount+' != '+expectedAmount+'\n');
            done();
        });
    });

    it('TEST 5 - should set variable `totalWeiRaisedDuringPreICO` correctly', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            var amount = await instance.totalWeiRaisedDuringPreICO.call();

            var outputAmount = amount.toNumber();
            var expectedAmount = web3.toWei(3, "ether");

            assert.equal(outputAmount, expectedAmount, 'Total ETH raised in PreICO was not calculated correctly\n'+outputAmount+' != '+expectedAmount+'\n');
            done();
        });
    });

    it('TEST 6 - should set stage to ICO', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            await instance.setCrowdsaleStage(1);
            const stage = await instance.stage.call();

            var outputAmount = stage.toNumber();
            var expectedAmount = 1;


            assert.equal(stage.toNumber(), 1, 'The stage couldn\'t be set to ICO\n'+outputAmount+' != '+expectedAmount+'\n');
            done();
        });
    });

    it('TEST 7 - one ETH should buy 1000 Together Tokens in ICO', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            const data = await instance.sendTransaction({from: accounts[2], value: web3.toWei(1, "ether")});
            const tokenAddress = await instance.token.call();
            const togetherToken = TogetherToken.at(tokenAddress);
            const tokenAmount = await togetherToken.balanceOf(accounts[2]);

            var outputAmount = new BigNumber(tokenAmount);
            var expectedAmount = new BigNumber(1000000000000000000);
            //even though we have converted it to bigNumber in order to do a equality check we have to cast the big number back to a number
            outputAmount = outputAmount.toNumber();
            expectedAmount = expectedAmount.toNumber();

            assert.equal(outputAmount, expectedAmount, 'The sender didn\'t receive the tokens as per ICO rate \n'+outputAmount+' != '+expectedAmount+'\n');
            done();
        });
    });

    it('TEST 8 - should transfer the raised ETH to RefundVault during ICO', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            var vaultAddress = await instance.vault.call();

            console.log("vault address: " + vaultAddress);

            let balance = await web3.eth.getBalance(vaultAddress);

            var outputAmount = new BigNumber(balance);
            var expectedAmount = new BigNumber(1000000000000000000);
            outputAmount = outputAmount.toNumber();
            expectedAmount = expectedAmount.toNumber();

            assert.equal(outputAmount, expectedAmount, 'ETH couldn\'t be transferred to the vault \n'+outputAmount+' != '+expectedAmount+'\n');
            done();
        });
    });

    it('TEST 9 - Vault balance should be added to our wallet once ICO is over', function (done) {


        TogetherCrowdsale.deployed().then(async function (instance) {
            let balanceOfBeneficiary = await web3.eth.getBalance(accounts[9]);
            balanceOfBeneficiary = balanceOfBeneficiary.toNumber();

            var vaultAddress = await instance.vault.call();
            let vaultBalance = await web3.eth.getBalance(vaultAddress);

            // todo: verify what this is doing exactly
            await instance.finish(accounts[0], accounts[1], accounts[2]);

            let newBalanceOfBeneficiary = await web3.eth.getBalance(accounts[9]);
            newBalanceOfBeneficiary = newBalanceOfBeneficiary.toNumber();
            //
            // var outputAmount = new BigNumber(newBalanceOfBeneficiary);
            // var expectedAmount = new BigNumber(balanceOfBeneficiary + vaultBalance.toNumber());
            // //even though we have converted it to bigNumber in order to do a equality check we have to cast the big number back to a number
            // outputAmount = outputAmount.toNumber();
            // expectedAmount = expectedAmount.toNumber();
            //
            //
            // assert.equal(outputAmount, expectedAmount, 'Vault balance '+vaultAddress+' couldn\'t be sent to the wallet '+accounts[9]+' \n'+outputAmount+' != '+expectedAmount+'\n');
            //

            assert.equal(newBalanceOfBeneficiary, balanceOfBeneficiary + vaultBalance.toNumber(), 'Vault balance couldn\'t be sent to the wallet');

            done();
        });
    });


  // Zonafide crowdsale tests

    it('TEST 10 -  should not allow purchase less that X ETH during Pre-ICO stage', function (done) {
        TogetherCrowdsale.deployed().then(async function (instance) {
            assert.isTrue(false);
            done();
        });
    });


});