// aluxdeploy.js
const { ethers } = require("hardhat");

async function main() {
  // Deploy CustomPaymentSplitter contract
  const CustomPaymentSplitter = await ethers.getContractFactory("CustomPaymentSplitter");
  const customPaymentSplitter = await CustomPaymentSplitter.deploy();

  await customPaymentSplitter.deployed();

  console.log("CustomPaymentSplitter contract deployed to:", customPaymentSplitter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });