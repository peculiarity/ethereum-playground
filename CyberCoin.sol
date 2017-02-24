solidity ^0.4.9;

contract CyberCoin {
    //Creating a map where the key is address and the value is a number.
    //Since this is public it will be visible to everyone.
    //The mapping is created into the contract storage.
    mapping (address => uint256) public balanceOf;
    
    //Constructor
    function CyberCoin(){
        balanceOf[msg.sender] = 10000;
    }
    
    //Creating a method that will be used to send amount 
    //from one account to another;
    function sendTo(address receiver, uint amount) returns(bool hasSufficient) {
        if(balanceOf[msg.sender] < amount ) return false;
        balanceOf[msg.sender] -= amount;
        balanceOf[receiver] += amount;
        return true;
    }
    
    //Just displays current sender's address
    function sender() returns(address senderAddress){
        return msg.sender;
    }
}
