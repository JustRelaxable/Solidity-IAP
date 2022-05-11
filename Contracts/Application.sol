pragma solidity >=0.7.0 <0.9.0;

struct Product{
    uint256 price;
    bool repurchasable;
}

contract Application {
    address private manager;
    address payable private owner;
    uint256 private nextProductIndex;
    mapping(uint256 => Product) private productDictionary;
    mapping(address => uint256[]) private userProducts;
    mapping(address => uint256) private userTransactionCount;

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

    function registerProduct(address to,uint256 productID) public onlyManager{
        userProducts[to].push(productID);
        userTransactionCount[to]++;
    }

    function getOwner() public view returns(address payable){
        return owner;
    }

    function getManager() public view returns(address){
        return manager;
    }

    function getProduct(uint256 productID) public view returns(Product memory){
        require(productID<nextProductIndex);
        return productDictionary[productID];
    }

    function getTransactionCount(address to) public view returns(uint256){
        return userTransactionCount[to];
    }

    function getTransactionProductID(address to,uint256 transactionID) public view returns(uint256){
        require(transactionID<getTransactionCount(to));
        return userProducts[to][transactionID];
    }
}