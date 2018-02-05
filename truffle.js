

let HDWalletProvider = require("truffle-hdwallet-provider");

let pnemonic ="" ;

let uat = "http://192.168.1.134:3090";

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
                return new HDWalletProvider(
                    pnemonic,
                    uat,0
                );
            },
            // exploring gas limit and gas price attributes
            // gas: 0x1c33c9, gasPrice: 0x756A528800,
            gas: 6500000,
            network_id: "777"
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    }
};
