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
    networks: {
      goerli: {
        url: process.env.GOERLI_URL,
        accounts: [process.env.DEPLOYER_PK],
      },
    },
    // gasReporter: {
    //   enabled: process.env.REPORT_GAS
    //     ? process.env.REPORT_GAS.toLocaleLowerCase() === "true"
    //     : false,
    //   currency: "JPY",
    //   coinmarketcap: process.env.CMC_API_KEY,
    // },
    etherscan: {
      apiKey: {
        goerli: process.env.ETHERSCAN_API_KEY,
      },
    },
    contractSizer: {
      // disambiguatePaths: true,
      runOnCompile: true,
      strict: true,
    },
  },
};
