import { network } from "hardhat";

async function main() {
    const connection = await network.getOrCreate();
    const { ethers } = connection;
    const [deployer] = await ethers.getSigners();
    console.log("部署账户:", deployer.address);
    console.log("账户余额:", ethers.formatEther(await ethers.provider.getBalance(deployer.address)));
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();
    
    await counter.waitForDeployment();
    const address = await counter.getAddress();
    
    console.log("Counter合约已部署到:", address);
    console.log("初始number值:", (await counter.getNumber()).toString());
    
    return address;
}

main()
    .then((address) => {
        console.log("部署成功，合约地址:", address);
        process.exit(0);
    })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });