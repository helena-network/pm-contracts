module.exports = function (deployer) {
    for(const contractName of [
        'CentralizedOracle',
        'FutarchyOracle',
        'MajorityOracle',
        'SignedMessageOracle',
        'UltimateOracle',
        'LighthouseOracle'
    ]) {
        deployer.deploy(artifacts.require(contractName))
    }
}
