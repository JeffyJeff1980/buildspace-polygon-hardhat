const main = async () => {
  const [owner] = await hre.ethers.getSigners();
  const domainContractFactory = await hre.ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy("gm");
  await domainContract.deployed();

  console.log("Contract deployed to:", domainContract.address);

  let txn = await domainContract.register("jeffyjeff", { value: hre.ethers.utils.parseEther("0.1") });

  await txn.wait();

  console.log("Minted domain jeffyjeff.gm - Owner: ", owner.address);

  txn = await domainContract.setRecord("jeffyjeff", owner.address);

  await txn.wait();
  console.log("Set address record for jeffyjeff.gm : ", owner.address);

  const balance = await hre.ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
};

const deployMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

deployMain();
