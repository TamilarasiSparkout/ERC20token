require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();
require("@openzeppelin/hardhat-upgrades");


const {BSC_RPC_URL, MONAD_RPC_URL, HOLESKY_RPC_URL, PRIVATE_KEY, BSC_API_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
   // holesky: {
   //   url: HOLESKY_RPC_URL,
   //   accounts: [`0x${PRIVATE_KEY}`],
   // },
   //  monad: {
   //    url: MONAD_RPC_URL,
   //    accounts: [`0x${PRIVATE_KEY}`],
   // },
     bscTestnet: {
       url: BSC_RPC_URL,
       accounts: [`0x${PRIVATE_KEY}`],
     }
     
  },
  sourcify: {
    enabled: true,
  },

  etherscan: {
    //apiKey: {
      //holesky: ETHERSCAN_API_KEY,
    //},
    //apiKey: {
    //  monad: ETHERSCAN_API_KEY,
    //},
    apiKey: {
      bscTestnet: BSC_API_KEY,
    }
  },
};

