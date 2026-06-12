// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract MyToken {
    // 1. 代币基本信息
    string public name;      // 代币名称，如："My Token"
    string public symbol;    // 代币符号，如："MTK"
    uint8 public decimals;   // 小数位数，通常为18
    uint256 public totalSupply;  // 总供应量

    // 2. 状态变量
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    bool public paused = false;
    
    // 3. 所有者（用于权限控制）
    address public immutable owner;

    //常量
    uint public constant RECIPIENTS_MAX = 50;

    // 4. 事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 5. 修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // 6. 构造函数
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**_decimals;
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// 转账
    /// @param to 收款地址
    /// @param amount 金额
    function transfer(address to, uint256 amount) 
        public whenNotPaused returns (bool) 
    {
        // 1. 检查接收地址
        require(to != address(0), "Cannot transfer to zero address");
        // 2. 检查余额
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");   
        // 3. 更新余额
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;        
        // 4. 触发事件
        emit Transfer(msg.sender, to, amount);        
        // 5. 返回成功
        return true;
    }

    /// 授权
    /// @param spender 授权方地址
    /// @param amount 金额
    function approve(address spender, uint256 amount) public whenNotPaused returns (bool) {
        // 1. 检查被授权人地址
        require(spender != address(0),"Cannot approve zero address");
        // 2. 设置授权额度
        allowance[msg.sender][spender] = amount;
        // 3. 触发事件
        emit Approval(msg.sender, spender, amount);
        // 4. 返回成功
        return true;
    }

    /// 三方转账
    /// @param from 扣款方地址
    /// @param to 收款方地址
    /// @param amount 金额
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public whenNotPaused returns (bool) {
        // 1. 检查地址有效性
        require(from != address(0), "From zero");
        require(to != address(0), "To zero");
        // 2. 检查余额
        require(balanceOf[from] >= amount, "Insufficient balance");
        // 3. 检查授权额度
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");        
        // 4. 执行转账
        balanceOf[from] -= amount;
        balanceOf[to] += amount;        
        // 5. 减少授权额度
        allowance[from][msg.sender] -= amount;       
        // 6. 触发事件
        emit Transfer(from, to, amount);       
        // 7. 返回成功
        return true;
    }

    /// 铸造功能
    /// @param to 接收方地址 
    /// @param amount 金额
    function mint(address to, uint256 amount) public onlyOwner  {
        require(to != address(0), "Cannot mint to zero address");
        
        totalSupply += amount;
        balanceOf[to] += amount;
        
        emit Transfer(address(0), to, amount);
    }
    /// 销毁功能
    /// @param amount 金额  
    function burn(uint256 amount) public  {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
        
        emit Transfer(msg.sender, address(0), amount);
    }

    /// 批量转账
    /// @param recipients 收款方列表
    /// @param amounts 金额
    function batchTransfer(
        address[] memory recipients,
        uint256[] memory amounts
    ) public whenNotPaused returns (bool) {
        require(recipients.length == amounts.length, "Length mismatch");
        require(recipients.length <= RECIPIENTS_MAX, "Batch too large");
        
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        
        require(balanceOf[msg.sender] >= totalAmount, "Insufficient balance");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid address");
            require(amounts[i] > 0, "Invalid amount");
        }
        
        for (uint256 i = 0; i < recipients.length; i++) {
            balanceOf[msg.sender] -= amounts[i];
            balanceOf[recipients[i]] += amounts[i];
            emit Transfer(msg.sender, recipients[i], amounts[i]);
        }
        
        return true;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

}