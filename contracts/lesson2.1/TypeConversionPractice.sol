// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract TypeConversionPractice {

    function safeConverToUint8(uint256  value) public pure returns(uint8){
        require(value <= type(uint8).max,"Value too large for uint8");
        return uint8(value);
    }

    function compareStrings(string memory a, string memory b) 
    public pure returns (bool) 
    {
        // 使用keccak256
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    function isZeroAddress(address addr) public pure returns (bool) {
        return addr == address(0);
    }

    // 额外测试函数
    function testConversion() public pure returns (uint8, uint8) {
        return (
            safeConverToUint8(255),  // 成功
            safeConverToUint8(100)   // 成功
            // safeConvertToUint8(256) // 会revert
        );
    }
    
    function testStringComparison() public pure returns (bool, bool) {
        return (
            compareStrings("Hello", "Hello"),  // true
            compareStrings("Hello", "World")   // false
        );
    }
    
    function testZeroAddress() public pure returns (bool, bool) {
        return (
            isZeroAddress(address(0)),                              // true
            isZeroAddress(0x0000000000000000000000000000000000001234)  // false
        );
    }
}