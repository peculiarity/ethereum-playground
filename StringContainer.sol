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
