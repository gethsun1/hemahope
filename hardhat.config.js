require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
        settings: {},
      },
      {
        version: "0.8.20", // Add support for Solidity version 0.8.20
        settings: {},
      },
    ],
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    rolx: {
      url: "https://json-rpc.rolxtwo.evm.ra.blumbus.noisnemyd.xyz",
      chainId: 100004,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
}
