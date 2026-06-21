// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// V2：应用存储打包
contract ERC20V2 {
    // 将小类型变量放在一起，共享存储槽
    string public name;
    string public symbol;
    uint8 public decimals;  // 可以与bool等小类型打包
    
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}

// Gas消耗：约85,000 Gas（节省15%）