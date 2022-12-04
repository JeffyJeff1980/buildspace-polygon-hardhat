require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.ALCHEMY_POLYGON_MUMBAI_API_KEY_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
