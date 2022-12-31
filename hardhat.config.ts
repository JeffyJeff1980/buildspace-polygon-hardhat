require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config({ path: ".env" });

module.exports = {
  solidity: "0.8.10",
  networks: {
    rinkeby: {
      url: process.env.ALCHEMY_RINKEBY_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    ropsten: {
      url: process.env.INFURA_ROPSTEN_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    goerli: {
      url: process.env.ALCHEMY_GOERLI_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    mainnet: {
      chainId: 1,
      url: process.env.ALCHEMY_MAINNET_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    mumbai: {
      url: process.env.ALCHEMY_POLYGON_MUMBAI_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    matic: {
      url: process.env.ALCHEMY_POLYGON_MAINNET_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
           apiKey: {
             polygon: process.env.POLYGONSCAN_API_KEY,
             polygonMumbai: process.env.POLYGONSCAN_API_KEY
           }
        }
};
