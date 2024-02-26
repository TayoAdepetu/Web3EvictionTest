import { ethers } from "hardhat";

async function main() {
  const contractWallet = "0x2B93dA0E4B315754F030Ab4260B09B108cB2cdB8";
  const getInventoryApp = await ethers.getContractAt(
    "ProductInventory",
    contractWallet
  );

  const new_employee = "0xDBF5E9c5206d0dB70a90108bf936DA60221dC080";

  const addNewEmployee = await getInventoryApp.addEmployee(new_employee);
  await addNewEmployee.wait();

  const getAllEmployees = await getInventoryApp.getAllEmployees();

  console.log(getAllEmployees);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
