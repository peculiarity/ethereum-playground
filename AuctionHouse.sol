pragma solidity 0.4.9;

contract AuctionHouse {
    
    //Used for debugging purposes only.
    event Print(uint256 output);
    event PrintAddr(address addr);
    
        //Easily can be handled by even listener on the client and implication is basically
    // Listening for new auctions, notifying an user and placing bids as fast as possible.
    event NewBid(uint256 amount,string item);
    event AuctionOpened(address seller, string item);
    event AuctionClosed(address seller, string item);
    
    enum AuctionState {Inactive,Active} //We want to track all new and previous auctions.
    
    modifier ifThereIsNoAuctionForTheUser() {
      var hasAlreadyAuction = auctions[msg.sender].isInitialized;
      if(hasAlreadyAuction) throw;
      _;  
    }
    
    modifier andBidderIsNotTheAuctionOwner(address seller){
        PrintAddr(seller);
        PrintAddr(msg.sender);
        if(seller == msg.sender) throw;
        _;
    }
    
    modifier ifAuctionExists (address seller){
      var hasAlreadyAuction = auctions[seller].isInitialized;
      if(!hasAlreadyAuction) throw;
      _;  
    }
    
    struct Auction {
        string item;
        Bid[] bids;
        AuctionState state;
        bool isInitialized; //used only because key in mapping  always maps toa value.
        //so by default boolean are false so what ever this default value it is not initialized
    }
    
    struct Bid {
        address issuer;
        uint256 amount;
    }
    
    mapping (address => Auction) public auctions;
    
    function startAuctionOf(string item) ifThereIsNoAuctionForTheUser {
        var seller = msg.sender;
        Auction newAuction;
        newAuction.item = item;
        newAuction.isInitialized = true;
            
        auctions[seller] = newAuction;
        AuctionOpened(seller,item);
    }
    
    function placeBid(address seller, uint256 amount) ifAuctionExists(seller) andBidderIsNotTheAuctionOwner(seller) returns (bool bidPlacedSuccessfully){
        var auction = auctions[seller];
        
        var bid = Bid(msg.sender,amount);
        
        if(auction.bids.length > 0) {
            var highestBid = auction.bids[auction.bids.length-1];
            
            Print(highestBid.amount);
            
            if(amount > highestBid.amount) {
                auction.bids.push(bid);
                NewBid(bid.amount, auction.item);
                return true;
            }  
               
            return false;
        } else {
            auction.bids.push(bid);
            Print(bid.amount);
            NewBid(bid.amount, auction.item);
            return true;
        }
    }
    
    function closeAuction() ifAuctionExists(msg.sender) returns (bool auctionClosedSuccessfully) {
        var auction = auctions[msg.sender];
        auction.isInitialized = false;
        auction.state = AuctionState.Inactive;
        
        AuctionClosed(msg.sender,auction.item);
        return true;
    }
}