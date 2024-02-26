// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductInventory {
    struct Product {
        uint256 id;
        string name;
        uint256 quantity;
    }

    address public owner;
    mapping(address => bool) public employees;
    mapping(uint256 => Product) public products;
    uint256 public nextProductId;
    address[] public allEmployees;

    event ProductAdded(
        uint256 indexed productId,
        string name,
        uint256 quantity
    );
    event ProductRemoved(uint256 indexed productId);
    event ProductQuantityUpdated(uint256 indexed productId, uint256 quantity);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyOwnerOrEmployee() {
        require(
            msg.sender == owner || employees[msg.sender],
            "Only the owner or employees can call this function"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addEmployee(address _employee) public onlyOwner {
        employees[_employee] = true;
    }

    function removeEmployee(address _employee) public onlyOwner {
        employees[_employee] = false;
    }

    function getAllEmployees() public view returns (address[] memory) {
        return allEmployees;
    }

    function addProduct(
        string memory _name,
        uint256 _quantity
    ) public onlyOwnerOrEmployee {
        uint256 productId = nextProductId++;
        products[productId] = Product(productId, _name, _quantity);
        emit ProductAdded(productId, _name, _quantity);
    }

    function removeProduct(uint256 _productId) public onlyOwnerOrEmployee {
        delete products[_productId];
        emit ProductRemoved(_productId);
    }

    function updateProductQuantity(
        uint256 _productId,
        uint256 _quantity
    ) public onlyOwnerOrEmployee {
        require(products[_productId].id != 0, "Product does not exist");
        products[_productId].quantity = _quantity;
        emit ProductQuantityUpdated(_productId, _quantity);
    }

    function getProduct(
        uint256 _productId
    ) public view returns (string memory name, uint256 quantity) {
        require(products[_productId].id != 0, "Product does not exist");
        Product memory product = products[_productId];
        return (product.name, product.quantity);
    }
}
