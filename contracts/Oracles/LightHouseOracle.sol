import "./Ilighthouse.sol";
import "./Ownable.sol"
import "../Oracles/Oracle.sol";




contract LightHouseOracle is Oracle, Ownable {
    
    event OutcomeAssignment(int outcome);

    ILighthouse  public myLighthouse;
    bool public isSet;
    int public outcome;


    constructor(ILighthouse _myLighthouse) public {
        myLighthouse = _myLighthouse;
    }

    /// @dev Sets event outcome
    function setOutcome()
        public
        onlyOwner
    {
        // Result is not set yet
        require(!isSet);
        
        uint128 data;
        bool ok = false;
        (data, ok) = myLighthouse.peekData();
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