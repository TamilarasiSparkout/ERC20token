require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();
require("@openzeppelin/hardhat-upgrades");


const { HOLESKY_RPC_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    holesky: {
      url: HOLESKY_RPC_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  sourcify: {
    enabled: true,
  },
  etherscan: {
    apiKey: {
      holesky: ETHERSCAN_API_KEY,
    },
  },
};
