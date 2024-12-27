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
