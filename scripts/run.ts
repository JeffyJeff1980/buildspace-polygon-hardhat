const hre = require("hardhat");

const mainRun = async () => {
  const [owner, intruder] = await hre.ethers.getSigners();
  const domainContractFactory = await hre.ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy("gm");
  await domainContract.deployed();

  console.log("Contract deployed to:", domainContract.address);

  // We're passing in a second variable - value. This is the moneyyyyyyyyyy
  let txn = await domainContract.register("jeffyjeff", { value: hre.ethers.utils.parseEther("0.1") });
  await txn.wait();

  txn = await domainContract.setRecord("jeffyjeff", owner.address);

  // Get all the domain names from our contract
  const names = await domainContract.getAllNames();
  console.log("All domain names:", names);

  await txn.wait();
  console.log("Set address record for jeffyjeff.gm : ", owner.address);

  console.log("Contract owner:", owner.address);
  // console.log("Intruder:", intruder.address);

  const balance = await hre.ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(balance));

  // Quick! Grab the funds from the contract! (as intruder)
  // txn = await domainContract.connect(intruder).withdraw();
  // await txn.wait();

  // Let's look in their wallet so we can compare later
  let ownerBalance = await hre.ethers.provider.getBalance(owner.address);
  console.log("Balance of owner before withdrawal:", hre.ethers.utils.formatEther(ownerBalance));

  // Oops, looks like the owner is saving their money!
  txn = await domainContract.connect(owner).withdraw();
  await txn.wait();

  // Fetch balance of contract & owner
  const contractBalance = await hre.ethers.provider.getBalance(domainContract.address);
  ownerBalance = await hre.ethers.provider.getBalance(owner.address);

  console.log("Contract balance after withdrawal:", hre.ethers.utils.formatEther(contractBalance));
  console.log("Balance of owner after withdrawal:", hre.ethers.utils.formatEther(ownerBalance));
};

const runMain = async () => {
  try {
    await mainRun();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
