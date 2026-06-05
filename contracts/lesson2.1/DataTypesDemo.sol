// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DataTypesDemo
 * @dev 演示Solidity各种数据类型的使用
 */
contract DataTypesDemo {
    
    // ========== 布尔类型 ==========
    bool public isActive = true;
    
    // ========== 整数类型 ==========
    uint256 public count = 100;
    int256 public balance = -50;
    uint8 public percentage = 75;
    
    // ========== 地址类型 ==========
    address public owner;
    address payable public recipient;
    
    // ========== 字节类型 ==========
    bytes32 public hash;
    bytes public data;
    
    // ========== 字符串类型 ==========
    string public name = "Solidity";
    string public description;
    
    // ========== 枚举类型 ==========
    enum Status { Pending, Approved, Rejected }
    Status public currentStatus;
    
    // ========== 事件 ==========
    event StatusChanged(Status newStatus);
    event MessageUpdated(string newMessage);
    
    // ========== 构造函数 ==========
    constructor() {
        owner = msg.sender;
        currentStatus = Status.Pending;
    }
    
    // ========== 布尔运算示例 ==========
    function checkActive() public view returns (bool) {
        return isActive && (count > 0);
    }
    
    function toggleActive() public {
        isActive = !isActive;
    }
    
    // ========== 整数运算示例 ==========
    function calculate(uint a, uint b) public pure returns (uint, uint, uint, uint) {
        return (
            a + b,   // 加法
            a * b,   // 乘法
            a / b,   // 除法
            a % b    // 取模
        );
    }
    
    function safeIncrement() public {
        // 使用checked算术（默认）
        count = count + 1;
    }
    
    // ========== 地址操作示例 ==========
    function getBalance(address addr) public view returns (uint) {
        return addr.balance;
    }
    
    function isZero(address addr) public pure returns (bool) {
        return addr == address(0);
    }
    
    function setRecipient(address _recipient) public {
        require(_recipient != address(0), "Invalid address");
        recipient = payable(_recipient);
    }
    
    // ========== 字符串操作示例 ==========
    function setDescription(string memory _desc) public {
        description = _desc;
        emit MessageUpdated(_desc);
    }
    
    function compareStrings(string memory a, string memory b) 
        public pure returns (bool) 
    {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
    
    function concatenate(string memory a, string memory b) 
        public pure returns (string memory) 
    {
        return string.concat(a, " ", b);
    }
    
    // ========== 字节操作示例 ==========
    function setHash(string memory input) public {
        hash = keccak256(bytes(input));
    }
    
    function addData(bytes1 b) public {
        data.push(b);
    }
    
    // ========== 枚举操作示例 ==========
    function approve() public {
        require(currentStatus == Status.Pending, "Not pending");
        currentStatus = Status.Approved;
        emit StatusChanged(Status.Approved);
    }
    
    function reject() public {
        require(currentStatus == Status.Pending, "Not pending");
        currentStatus = Status.Rejected;
        emit StatusChanged(Status.Rejected);
    }
    
    function getStatusAsUint() public view returns (uint) {
        return uint(currentStatus);
    }
    
    // ========== 类型转换示例 ==========
    function safeConvertToUint8(uint256 value) 
        public pure returns (uint8) 
    {
        require(value <= type(uint8).max, "Overflow");
        return uint8(value);
    }
    
    function addressToUint(address addr) public pure returns (uint160) {
        return uint160(addr);
    }
    
    // ========== 辅助函数 ==========
    function getTypeInfo() public pure returns (uint8, uint256, int256) {
        return (
            type(uint8).max,    // 255
            type(uint256).max,  // 2^256-1
            type(int256).min    // -2^255
        );
    }
}