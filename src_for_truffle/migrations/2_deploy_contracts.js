const UCSC = artifacts.require("UCSC");
const TCSC = artifacts.require("TCSC");
const DCCSC = artifacts.require("DCCSC");

module.exports = function(deployer) {
  deployer.deploy(UCSC);
  deployer.deploy(TCSC);
  deployer.deploy(DCCSC);
}
