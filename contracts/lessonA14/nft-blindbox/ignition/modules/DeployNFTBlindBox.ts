import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

/**
 * NFT盲盒部署模块（仅部署实现合约）
 * 
 * 注意：由于Ignition和OpenZeppelin Upgrades插件的集成限制，
 * 推荐使用 scripts/deployWithUUPS.ts 进行完整部署。
 * 
 * 这个模块仅用于部署实现合约，代理部署请使用OpenZeppelin Upgrades插件。
 */
const DeployNFTBlindBoxModule = buildModule("DeployNFTBlindBox", (m) => {
  // const name = m.getParameter<string>("name", "Mystery NFT");
  // const symbol = m.getParameter<string>("symbol", "MNFT");
  // const maxSupply = m.getParameter<bigint>("maxSupply", 10000n);
  // const price = m.getParameter<bigint>("price", 80000000000000000n);

  const implementation = m.contract("NFTBlindBoxUpgradeable");

  // ✅ 只返回合约 Future，不要返回参数
  return { implementation };
});

export default DeployNFTBlindBoxModule;

