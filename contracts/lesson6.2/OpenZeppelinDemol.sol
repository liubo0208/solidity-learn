// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract OpenZeppelinDemo {
    using Strings for uint256;
    using Address for address;
    
    // 使用Strings库
    function numberToString(uint256 num) public pure returns (string memory) {
        return num.toString();
    }
    
    // 使用Address库 v4.x
    // function checkContract(address addr) public view returns (bool) {
    //     return addr.isContract();
    // }
    
    // 组合使用
    // function getInfo(address addr) public view returns (string memory) {
    //     if (addr.isContract()) {
    //         return "This is a contract address";
    //     } else {
    //         return "This is an EOA address";
    //     }
    // }

     // ✅ v5.x 直接使用 addr.code.length
    function checkContract(address addr) public view returns (bool) {
        return addr.code.length > 0;
    }

    // ✅ 组合使用
    function getInfo(address addr) public view returns (string memory) {
        if (addr.code.length > 0) {
            return "This is a contract address";
        } else {
            return "This is an EOA address";
        }
    }
}