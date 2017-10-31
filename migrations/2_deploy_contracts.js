var BytesLib = artifacts.require("./BytesLib.sol");

module.exports = function(deployer) {
  deployer.deploy(BytesLib);
};
