pragma solidity ^0.4.24;
import "../Oracles/LighthouseOracle.sol";


/// @title Centralized oracle factory contract - Allows to create centralized oracle contracts
/// @author Stefan George - <stefan@gnosis.pm>
contract LighthouseOracleFactory {

    /*
     *  Events
     */
    event CentralizedOracleCreation(address indexed creator, LighthouseOracle lighthouseOracle, bytes ipfsHash, address lighthouse);

    /*
     *  Storage
     */
    LighthouseOracle public lighthouseOracleMasterCopy;

    /*
     *  Public functions
     */
    constructor(LighthouseOracle _lighthouseOracleMasterCopy)
        public
    {
        lighthouseOracleMasterCopy = _lighthouseOracleMasterCopy;
    }

    /// @dev Creates a new centralized oracle contract
    /// @param ipfsHash Hash identifying off chain event description
    /// @param lighthouse Address of the lighthouse contract offering the winning outcome
    /// @return Oracle contract
    function createCentralizedOracle(bytes ipfsHash, address lighthouse)
        public
        returns (LighthouseOracle lighthouseOracle)
    {
        lighthouseOracle = LighthouseOracle(new LighthouseOracleProxy(lighthouseOracleMasterCopy, msg.sender, ipfsHash, lighthouse));
        emit CentralizedOracleCreation(msg.sender, lighthouseOracle, ipfsHash, lighthouse);
    }
}
