pragma solidity ^0.4.24;

import "./ILighthouse.sol";
import "./Ownable.sol";
import "../Oracles/Oracle.sol";



contract LightHouseOracleData {

    /*
     *  Events
     */
    event OwnerReplacement(address indexed newOwner);
    event OutcomeAssignment(int outcome);

    /*
     *  Storage
     */
    ILighthouse  public myLightHouse;
    address public owner;
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



contract LightHouseOracleProxy is Proxy, LightHouseOracleData {

    /// @dev Constructor sets owner address and IPFS hash
    /// @param _ipfsHash Hash identifying off chain event description
    constructor(address proxied, address _myLightHouse, address _owner, bytes _ipfsHash)
        public
        Proxy(proxied)
    {
        // Description hash cannot be null
        require(_ipfsHash.length == 46);
        owner = _owner;
        myLightHouse = ILighthouse(_myLightHouse);
        ipfsHash = _ipfsHash;
    }
}

contract LightHouseOracle is Proxied, Oracle, LightHouseOracleData {
    
    event OutcomeAssignment(int outcome);
    address centralizedOracle;
    bool public isSet;
    int public outcome;


    constructor(ILighthouse _myLightHouse) public {
        myLightHouse = _myLightHouse;
    }

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
        //require(!isSet);
        
        uint128 data;
        bool ok = false;
        (data, ok) = myLightHouse.peekData();
        require(ok);
        outcome = data;
        isSet = true;
        emit OutcomeAssignment(data);
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