const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  const lotteryContract = await ethers.getContractFactory("Lottery");

  // here we deploy the contract
  const deployedLotteryContract = await lotteryContract.deploy();
  console.log("Deploying Lottery Contract...");
  // console.log(cryptoDevTokenAddress);
  await deployedLotteryContract.deployed();

  // print the address of the deployed contract
  console.log("Lottery Contract Address:", deployedLotteryContract.address);

  const lottery = await lotteryContract.attach(deployedLotteryContract.address);


  console.log(await lottery.getBalance());
  console.log(await lottery.getPlayers());

  await lottery.enter({
    value: ethers.utils.parseEther(".0001")
  });


  console.log(await lottery.getBalance());
  console.log(await lottery.getPlayers());

  console.log("END");
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });