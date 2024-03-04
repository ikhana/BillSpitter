// mugglepaydeploy.js
const { ethers } = require("hardhat");

async function main() {
  // Deploy MugglePay contract
  const MugglePay = await ethers.getContractFactory("MugglePay");
  const mugglePay = await MugglePay.deploy();

  await mugglePay.deployed();

  console.log("MugglePay token deployed to:", mugglePay.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });