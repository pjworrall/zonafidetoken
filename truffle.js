

let HDWalletProvider = require("truffle-hdwallet-provider");

let kim_simmonds_pnemonic ="" ;

let jack_white_pnemonic ="" ;

let uat = "http://192.168.1.134:3090";

let public = "http://zonafide.space:3090";

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 7545,
            gas: 6500000,
            network_id: "5777"
        },
        uat: {
            provider: function() {
                // todo - we have an outstanding pull request to support a HD Wallet Path as an argument
                // https://github.com/pjworrall/truffle-hdwallet-provider
                return new HDWalletProvider(
                    kim_simmonds_pnemonic,
                    uat,0
                );
            },
            // exploring gas limit and gas price attributes
            // gas: 0x1c33c9, gasPrice: 0x756A528800,
            //gas: 6500000,
            gas: 6500000,
            network_id: "777"
        },
        public: {
            provider: function() {
                // todo - we have an outstanding pull request to support a HD Wallet Path as an argument
                // https://github.com/pjworrall/truffle-hdwallet-provider
                return new HDWalletProvider(
                    jack_white_pnemonic,
                    public,0
                );
            },
            // exploring gas limit and gas price attributes
            // gas: 0x1c33c9, gasPrice: 0x756A528800,
            //gas: 6500000,
            gas: 6500000,
            network_id: "888"
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
