pragma solidity 0.4.9;


contract StringContainer {
    
    string[] public listOfStrings;
    StringUtils utils = new StringUtils();    
    
    function add(string memory newString) returns (bool success){
        
        for(uint index=0;index<listOfStrings.length;index++) {
            if(utils.equals(listOfStrings[index], newString)){
                return false;
            }
        }
        
        listOfStrings.push(newString);
        return true;
    }    
}


contract StringUtils {
    
    // constant is used to mark that the method doesn't change any state.
    // bear in mind that the compiler doesn't force function not to change the internal state yet
    function equals(string memory first,string memory second) constant returns (bool areEqual){
        bytes  memory bytesFirst =  bytes(first);
        bytes  memory bytesSecond = bytes(second);
        
        if(bytesFirst.length != bytesSecond.length){
            return false;
        } else {
            for (uint i = 0; i < bytesFirst.length; i++)
			if (bytesFirst[i] != bytesSecond[i])
				return false;
        }
        
        return true;
    }
    
}
