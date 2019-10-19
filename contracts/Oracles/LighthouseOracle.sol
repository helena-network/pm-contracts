pragma solidity ^0.4.24;
import "../Oracles/Oracle.sol";
import "@gnosis.pm/util-contracts/contracts/Proxy.sol";

interface ILighthouse {
    function peekData() external view returns (uint128 v,bool b);
    function peekUpdated()  external view returns (uint32 v,bool b);
    function peekLastNonce() external view returns (uint32 v,bool b);
    function peek() external view returns (bytes32 v ,bool ok);
    function read() external view returns (bytes32 x);
}

contract LighthouseOracleData {

    /*
     *  Events
     */
    event OwnerReplacement(address indexed newOwner);
    event OutcomeAssignment(int outcome);

    /*
     *  Storage
     */
    address public owner;
    address public oracle;
    ILighthouse public lighthouse;
    bytes public ipfsHash;
    bool public isSet;
    int public outcome;

    /*
     *  Modifiers
     */
    modifier isOwner () {
        // Only owner is allowed to proceed
        require(msg.sender == owner);
        _;
    }
}

contract LighthouseOracleProxy is Proxy, LighthouseOracleData {

    /// @dev Constructor sets owner address and IPFS hash
    /// @param _ipfsHash Hash identifying off chain event description
    /// @param _oracle Address of the contract offering the final outcome
    constructor(address proxied, address _owner, bytes _ipfsHash, address _oracle)
        public
        Proxy(proxied)
    {
        // Description hash cannot be null
        require(_ipfsHash.length == 46);
        owner = _owner;
        ipfsHash = _ipfsHash;
        oracle = _oracle;
        lighthouse = ILighthouse(_oracle);
    }
}

/// @title Centralized oracle contract - Allows the contract owner to set an outcome
/// @author Stefan George - <stefan@gnosis.pm>
contract LighthouseOracle is Proxied, Oracle, LighthouseOracleData {

    /*
     *  Public functions
     */
    /// @dev Replaces owner
    /// @param newOwner New owner
    function replaceOwner(address newOwner)
        public
        isOwner
    {
        // Result is not set yet
        require(!isSet);
        owner = newOwner;
        emit OwnerReplacement(newOwner);
    }

    /// @dev Sets event outcome
    function setOutcome()
        public
        isOwner
    {
        // Result is not set yet
        require(!isSet);
        isSet = true;
        (outcome, ) = lighthouse.peekData();
        emit OutcomeAssignment(outcome);
    }

    /// @dev Returns if winning outcome is set
    /// @return Is outcome set?
    function isOutcomeSet()
        public
        view
        returns (bool)
    {
        return isSet;
    }

    /// @dev Returns outcome
    /// @return Outcome
    function getOutcome()
        public
        view
        returns (int)
    {
        return outcome;
    }
}
