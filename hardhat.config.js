require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");


require('dotenv').config();

module.exports = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    hardhat: {},
    goerli: {
      url: process.env.GOERLI_URL,
      accounts: [process.env.DEPLOYER_PK],
    },
  },
  etherscan: {
    apiKey: {
      goerli: process.env.ETHERSCAN_API_KEY,
    },
  },
  contractSizer: {
    // disambiguatePaths: true,
    runOnCompile: true,
    strict: true,
  }
};