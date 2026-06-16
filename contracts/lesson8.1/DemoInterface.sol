// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 定义ERC20接口
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

// 简单的ERC20代币实现（用于演示）
/// @custom:wake-disable incorrect-interface
contract SimpleToken is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply * 10**decimals;
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(_allowances[from][msg.sender] >= amount, "Insufficient allowance");
        require(_balances[from] >= amount, "Insufficient balance");
        
        _allowances[from][msg.sender] -= amount;
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
    
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }
}

// 代币交换合约（使用接口调用）
contract TokenSwap {
    // 声明两个代币接口变量
    IERC20 public tokenA;
    IERC20 public tokenB;
    
    // 交换事件：记录每次交换的详细信息
    event Swap(
        address indexed user,
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut
    );
    
    // 构造函数：初始化代币合约地址
    constructor(address _tokenA, address _tokenB) {
        // 将地址转换为接口类型
        // 这样编译器会检查这些地址对应的合约是否实现了接口中的函数
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }
    
    /**
     * @notice 执行代币交换
     * @param amountA 要交换的tokenA数量
     * @dev 用户需要先调用tokenA的approve函数授权本合约使用其代币
     */
    function swap(uint256 amountA) external {
        // 步骤1：检查合约是否有足够的tokenB用于交换
        // 使用接口的view函数查询余额，不消耗Gas
        uint256 contractBalanceB = tokenB.balanceOf(address(this));
        require(contractBalanceB >= amountA, "Insufficient tokenB in contract");
        
        // 步骤2：从用户账户转移tokenA到本合约
        // transferFrom需要用户先调用tokenA.approve授权本合约
        // 如果转账失败，require会回滚整个交易
        require(
            tokenA.transferFrom(msg.sender, address(this), amountA),
            "TokenA transfer failed"
        );
        
        // 步骤3：从本合约向用户转移tokenB
        // 简化示例：1:1兑换比例
        uint256 amountB = amountA;
        require(
            tokenB.transfer(msg.sender, amountB),
            "TokenB transfer failed"
        );
        
        // 步骤4：触发事件，记录交换信息
        // 前端应用可以监听这个事件来更新UI
        emit Swap(msg.sender, address(tokenA), address(tokenB), amountA, amountB);
    }
    
    /**
     * @notice 查询合约持有的代币余额
     * @return balanceA 合约持有的tokenA数量
     * @return balanceB 合约持有的tokenB数量
     */
    function getContractBalances() 
        external 
        view 
        returns (uint256 balanceA, uint256 balanceB) 
    {
        // 使用接口的view函数查询余额
        // view函数不修改状态，外部调用不消耗Gas
        balanceA = tokenA.balanceOf(address(this));
        balanceB = tokenB.balanceOf(address(this));
    }
    
    /**
     * @notice 查询用户持有的代币余额
     * @param user 要查询的用户地址
     * @return balanceA 用户的tokenA余额
     * @return balanceB 用户的tokenB余额
     */
    function getUserBalances(address user) 
        external 
        view 
        returns (uint256 balanceA, uint256 balanceB) 
    {
        balanceA = tokenA.balanceOf(user);
        balanceB = tokenB.balanceOf(user);
    }

    
    
}