const LightHouse = artifacts.require('LightHouse')
const LightHouseOracle = artifacts.require(('LightHouseOracle'))

module.exports = function (deployer) {
    deployer.deploy(LightHouse);
}
