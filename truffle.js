const HDWalletProvider = require('truffle-hdwallet-provider')
require('dotenv').config()
const mnemonic =process.env["MNEMONIC"];

const config = {
    networks: {
        dev: {
            host: "127.0.0.1",
            network_id: "*",
            port: 8545
        },
        mainnet: {
            host: "localhost",
            port: 8545,
            network_id: "1",
        },
        ropsten: {
            host: "localhost",
            port: 8545,
            network_id: "3",
        },
        xdai: {
            provider: function () {
                return new HDWalletProvider(mnemonic, 'https://dai.poa.network')
              },
            network_id: "*"
        },
        kovan: {
            host: "localhost",
            port: 8545,
            network_id: "42",
        },
        rinkeby: {
            provider: function () {
                return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/f837a713a0d244b5a67c5b2da01e03d9')
              },
            network_id: "4",
        },
        quickstart: {
            host: "localhost",
            port: 8545,
            network_id: "437894314312",
        },
    },
    mocha: {
        enableTimeouts: false,
        grep: process.env.TEST_GREP
    }
}

const _ = require('lodash')

try {
    _.merge(config, require('./truffle-local'))
}
catch(e) {
    if(e.code === 'MODULE_NOT_FOUND' && e.message.includes('truffle-local')) {
        // eslint-disable-next-line no-console
        console.log('No local truffle config found. Using all defaults...')
    } else {
        // eslint-disable-next-line no-console
        console.warn('Tried processing local config but got error:', e)
    }
}

module.exports = config
