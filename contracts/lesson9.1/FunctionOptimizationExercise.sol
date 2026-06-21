// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title 函数优化
/// @author liubo
/// @notice Notice
/// @dev Development
contract FunctionOptimizationExercise {
    mapping(address => uint256) public balances;
    
    function transfer(address to, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(to != address(0), "Invalid recipient");
        require(expensiveCheck(), "Expensive check failed");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    
    function expensiveCheck() internal view returns (bool) {
        // 模拟昂贵的检查
        return true;
    }
}