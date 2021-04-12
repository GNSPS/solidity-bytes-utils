const HDWalletProvider = require('@truffle/hdwallet-provider')
const fs = require('fs')

// First read in the secrets.json to get our mnemonic
let secrets
let mnemonic
if (fs.existsSync('secrets.json')) {
  secrets = JSON.parse(fs.readFileSync('secrets.json', 'utf8'))
  mnemonic = secrets.mnemonic
} else {
  console.log('No secrets.json found. If you are trying to publish EPM ' +
              'this will fail. Otherwise, you can ignore this message!')
  // Example mnemonic below. PLEASE DON'T USE FOR ANYTHING ELSE!
  mnemonic = 'wrist find shock leisure stand barely field sunset script evidence key idea diesel journey gravity'
}

module.exports = {
  networks: {
    live: {
      provider: () => new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/v3/130dfea36eb541b79694f0b6c003b2b2'),
      network_id: 1 // Ethereum public network
      // optional config values
      // host - defaults to "localhost"
      // port - defaults to 8545
      // gas
      // gasPrice
      // from - default address to use for any transaction Truffle makes during migrations
    },
    ropsten: {
      provider: () => new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/v3/130dfea36eb541b79694f0b6c003b2b2'),
      network_id: '3'
    },
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    // ganache: {
    //   host: "localhost",
    //   port: 7545,
    //   network_id: "*" // Match any network id
    // },
  },
  compilers: {
    solc: {
      version: "0.8.3", // A version or constraint - Ex. "^0.5.0"
    }
  }
};
