// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// V3：应用unchecked和external
contract ERC20V3 {
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
    
    // 使用external而不是public
    function transfer(address to, uint256 amount) external returns (bool) {
        uint256 senderBalance = balanceOf[msg.sender];
        require(senderBalance >= amount, "Insufficient balance");
        
        // 使用unchecked，因为已经检查过
        unchecked {
            balanceOf[msg.sender] = senderBalance - amount;
        }
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}

// Gas消耗：约70,000 Gas（累计节省30%）