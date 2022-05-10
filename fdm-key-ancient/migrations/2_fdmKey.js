const fdmKey = artifacts.require("fdmKey");

module.exports = function (deployer) {
  deployer.deploy(fdmKey);
};