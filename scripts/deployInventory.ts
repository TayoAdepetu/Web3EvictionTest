import { ethers } from "hardhat";

async function main() {
  const deployInventory = await ethers.deployContract("ProductInventory");

  await deployInventory.waitForDeployment();

  console.log(
    `Product Inventory Contract Deployed To Address: ${deployInventory.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
