// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Token {
    mapping(address => uint256) public balanceOf;
    
    function transfer(address to, uint256 amount) public {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}