const main = async () => {
  const contractName = "Domains"
  const networkName = hre.network.name
  const [owner] = await hre.ethers.getSigners();

  console.log('Deploying contracts with the account:', owner.address);
  console.log('Account balance:', (await owner.getBalance() / 10 ** 18).toString());
  console.log('Network:', networkName)


  const domainContractFactory = await hre.ethers.getContractFactory(contractName);
  const domainContract = await domainContractFactory.deploy("gm");
  await domainContract.deployed();

  console.log(`${contractName} Contract deployed to:`, domainContract.address);

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
