// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleManagement {
    //  定义角色枚举
    enum Role { None, User, Admin, Owner }
    
    // 存储用户角色
    mapping(address => Role) public roles;
    
    address public owner;

    event RoleAssigned(address indexed user, Role role);
    event RoleRevoked(address indexed user);

    constructor() {
        owner = msg.sender;
        roles[msg.sender] = Role.Owner;
        emit RoleAssigned(msg.sender, Role.Owner);
    }
    
    // 定义modifier
    modifier onlyOwner() {
        // 检查是否为Owner
        require(roles[msg.sender] == Role.Owner , "Only owner can call");
        _;
    }
    
    modifier onlyAdmin() {
        // 检查是否为Admin或Owner
        require(
            roles[msg.sender] == Role.Admin || roles[msg.sender] == Role.Owner,
            "Only admin or owner can call"
        );
        _;
    }

    modifier onlyUser() {
        require(roles[msg.sender] != Role.None, "Must have a role");
        _;
    }
    
    // 实现功能函数
    function addAdmin(address user) public onlyOwner {
        // Owner添加Admin
        require(user != address(0), "Invalid address");
        require(roles[user] != Role.Owner, "Cannot change owner role");
        roles[user] = Role.Admin;
        emit RoleAssigned(user, Role.Admin);
    }
    
    function addUser(address user) public onlyAdmin {
        // Admin添加User
        require(user != address(0), "Invalid address");
        require(roles[user] != Role.Owner, "Cannot change owner role");
        roles[user] = Role.User;
        emit RoleAssigned(user, Role.User);
    }
    

    function revokeRole(address user) public onlyOwner {
        require(user != owner, "Cannot revoke owner role");
        delete roles[user];
        emit RoleRevoked(user);
    }
    function getRole(address user) public view  returns (Role) {
        // 查询角色
        return roles[user];
    }
    
    function hasRole(address user, Role role) public view returns (bool) {
        return roles[user] == role;
    }
}