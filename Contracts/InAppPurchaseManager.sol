pragma solidity >=0.7.0 <0.9.0;
import "./Application.sol";

contract InAppPurchaseManager {
    event ProductPurchased(address,uint256);

    uint256 private nextApplicationID;
    mapping(uint256 => Application) public applicationDictionary;

    function createApplication() public returns(address) {
        Application app = new Application(msg.sender);
        applicationDictionary[nextApplicationID] = app;
        nextApplicationID += 1;
        return address(app);
    }

    function purchaseProduct(uint256 applicationID,uint256 productID,address to) public payable{
        Application application = applicationDictionary[applicationID];
        Product memory product = application.getProduct(productID);
        if(msg.value==product.price){
            application.getOwner().transfer(msg.value);
            application.registerProduct(to,productID);
            emit ProductPurchased(to,productID);
        } 
        else{
            revert();
        }
    }

    function getTransactionProductID(uint256 applicationID,uint256 transactionID) public view returns(uint256){
        Application application = applicationDictionary[applicationID];
        return application.getTransactionProductID(msg.sender,transactionID);
    }

    function getTransactionCount(uint256 applicationID) public view returns(uint256){
        Application application = applicationDictionary[applicationID];
        return application.getTransactionCount(msg.sender);
    }
}