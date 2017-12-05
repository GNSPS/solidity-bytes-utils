module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ganache: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    },
  }
};
