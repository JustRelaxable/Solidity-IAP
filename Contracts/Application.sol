pragma solidity >=0.7.0 <0.9.0;

struct Product{
    uint256 price;
    bool repurchasable;
}

contract Application {
    address public manager;
    address payable public owner;
    uint256 private nextProductIndex;
    mapping(uint256 => Product) public productDictionary;
    mapping(address => uint256[]) public userProducts;
    mapping(address => uint256) public userTransactionCount;

    constructor(address creator){
        manager = msg.sender;
        owner=payable(creator);
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier onlyManager(){
        require(msg.sender == manager);
        _;
    }

    function createProduct(uint256 price,bool repurchasable) public onlyOwner{
        Product memory p = Product(price,repurchasable);
        productDictionary[nextProductIndex] = p;
        nextProductIndex++;
    }

    function getProduct(uint256 productID) public view returns(Product memory){
        require(productID<nextProductIndex);
        return productDictionary[productID];
    }

    function getOwner() public view returns(address payable){
        return owner;
    }

    function registerProduct(address to,uint256 productID) public onlyManager{
        userProducts[to].push(productID);
        userTransactionCount[to]++;
    }

    function getTransactionProductID(address to,uint256 transactionID) public view returns(uint256){
        return userProducts[to][transactionID];
    }

    function getTransactionCount(address to) public view returns(uint256){
        return userTransactionCount[to];
    }
}