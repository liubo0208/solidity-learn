// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/Counter.sol";

contract DeployCounter is Script {
    function run() external {
        // 从环境变量读取私钥
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying from:", deployer);
        console.log("Balance:", deployer.balance);
        
        // 开始广播交易
        vm.startBroadcast(deployerPrivateKey);
        
        // 部署合约
        Counter counter = new Counter();
        
        // 部署后调用初始化函数
        counter.setNumber(100);

        // 停止广播
        vm.stopBroadcast();
        
        // 输出部署地址
        console.log("Counter deployed at:", address(counter));
        console.log("Initial number:", counter.number());
    }
}