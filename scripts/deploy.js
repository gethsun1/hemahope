// scripts/deploy.js
async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const UserManagement = await ethers.getContractFactory("UserManagement");
  const userManagement = await UserManagement.deploy();

  console.log("UserManagement deployed to:", userManagement.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
