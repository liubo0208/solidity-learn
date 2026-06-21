// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// V4：应用局部存储指针
contract ERC20V4 {
    string public name;
    string public symbol;
    uint8 public decimals;
    
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
    
    function transfer(address to, uint256 amount) external returns (bool) {
        // 使用局部存储指针
        uint256 senderBalance = balanceOf[msg.sender];
        require(senderBalance >= amount, "Insufficient balance");
        
        unchecked {
            balanceOf[msg.sender] = senderBalance - amount;
        }
        
        // 使用局部存储指针访问接收者余额
        uint256 receiverBalance = balanceOf[to];
        balanceOf[to] = receiverBalance + amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}

// Gas消耗：约65,000 Gas（累计节省35%）