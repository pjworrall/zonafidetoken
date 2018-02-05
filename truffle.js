

let HDWalletProvider = require("truffle-hdwallet-provider");

let pnemonic ="" ;

let development = "http://192.168.1.134:3090";

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 7545,
            network_id: "5777"
        },
        uat: {
            provider: function() {
                return new HDWalletProvider(
                    pnemonic,
                    development,0
                );
            },
            // exploring gas limit and gas price attributes
            // gas: 0x1c33c9, gasPrice: 0x756A528800,
            network_id: "777"
        }
    }
};
