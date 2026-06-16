// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleBank {
    // 自定义错误
    error InsufficientBalance(address account, uint256 available, uint256 required);
    error InvalidAmount(uint256 amount);
    error WithdrawalFailed();

    mapping(address => uint256) public balances;

    // 重入锁状态变量
    bool private _locked;

    // 重入锁修饰符
    modifier nonReentrant() {
        require(!_locked, "ReentrancyGuard: reentrant call");
        _locked = true;
        _;
        _locked = false;
    }

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    /**
     * @notice 存款
     */
    function deposit() public payable {
        require(msg.value > 0, unicode"存款金额必须大于0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice 取款
     */
    function withdraw(uint256 amount) public nonReentrant {  // 👈 添加修饰符
        // 输入验证
        if (amount == 0) revert InvalidAmount(amount);
        
        // 余额检查
        if (balances[msg.sender] < amount) {
            revert InsufficientBalance(msg.sender, balances[msg.sender], amount);
        }
        
        // 更新状态
        balances[msg.sender] -= amount;
        
        // 转账
        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) revert WithdrawalFailed();  // 👈 删除冗余的余额恢复
        
        emit Withdrawal(msg.sender, amount);
    }

    /**
     * @notice 查询余额
     */
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
