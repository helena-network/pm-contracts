pragma solidity ^0.4.24;
import "../Oracles/LightHouseOracle.sol";





/// @title LightHouse oracle factory contract - Allows to create lightHouse oracle contracts
/// @author Carlos Buendía - <carlos.buendia@helena.network>
contract LightHouseOracleFactory {

    /*
     *  Events
     */
    event LightHouseOracleCreation(address indexed creator, LightHouseOracle lightHouseOracle, bytes ipfsHash);

    /*
     *  Storage
     */
    LightHouseOracle public lightHouseOracleMasterCopy;

    /*
     *  Public functions
     */
    constructor(LightHouseOracle _lightHouseOracleMasterCopy)
        public
    {
        lightHouseOracleMasterCopy = _lightHouseOracleMasterCopy;
    }

    /// @dev Creates a new lightHouse oracle contract
    /// @param ipfsHash Hash identifying off chain event description
    /// @return Oracle contract
    function createLightHouseOracle(bytes ipfsHash, address lightHouse)
        public
        returns (LightHouseOracle lightHouseOracle)
    {
        lightHouseOracle = LightHouseOracle(new LightHouseOracleProxy(lightHouseOracleMasterCopy, lightHouse, msg.sender, ipfsHash));
        emit LightHouseOracleCreation(msg.sender,  lightHouseOracle, ipfsHash);
    }
}
