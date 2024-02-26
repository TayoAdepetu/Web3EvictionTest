import { ethers } from "hardhat";

async function main() {
  const contractWallet = "0x78984Bd5bBDbf9bC0DEbE18227F61064E4ab2cA7";
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
