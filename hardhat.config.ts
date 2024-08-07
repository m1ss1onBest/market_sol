import 'solidity-docgen';
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("solidity-docgen");

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  docgen: {
    outputDir: "./docs",
  }
};

export default config;
