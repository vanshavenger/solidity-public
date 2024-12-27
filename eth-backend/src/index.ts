import { JsonRpcProvider } from "ethers";
import "dotenv/config";
import { USDT_ADDRESS } from "./constants";

const provider = new JsonRpcProvider(Bun.env.MAINNET_URL);

const pollBlock = async (blockNumber: number) => {
  const logs = await provider.getLogs({
    address: USDT_ADDRESS,
    fromBlock: blockNumber,
    toBlock: blockNumber,
  });

  for (const log of logs) {
    console.log(log.blockNumber);
  }
};

pollBlock(21495523);


console.log("0x" + "0x000000000000000000000000c88d82868118f23cdbb41fc8f0457ece17f4e615".slice(26));