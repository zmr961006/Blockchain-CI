const UCSC = artifacts.require("UCSC");
const TCSC = artifacts.require("TCSC");
const DCCSC = artifacts.require("DCCSC");

module.exports = function(deployer,network,accounts) {
  deployer.deploy(UCSC,{from: accounts[0]});
  deployer.deploy(UCSC,{from: accounts[0]});
  deployer.deploy(UCSC,{from: accounts[0]});
};
