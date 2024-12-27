import { JsonRpcProvider, formatUnits, ethers, id, formatEther } from "ethers";
import "dotenv/config";
import { TARGET_ADDRESS, USDT_ADDRESS } from "./constants";
import { sleep } from "bun";

let BatchSize = 10000;

const provider = new JsonRpcProvider(Bun.env.MAINNET_URL);

const getCurrentBalanceFromContract = async (): Promise<string> => {
  const balance = await provider.getBalance(TARGET_ADDRESS);
  return ethers.formatEther(balance);
};

function formatProgress(current: number, total: number): string {
  const percentage = ((current / total) * 100).toFixed(2);
  const progress = "#"
    .repeat(Math.floor((current / total) * 20))
    .padEnd(20, "-");
  return `[${progress}] ${percentage}%`;
}

const getBalanceFromStart = async (
  startBlock: number,
  endBlock: number,
): Promise<string> => {
  let balance = 0n;
  const totalBlocks = endBlock - startBlock;
  console.log(`Total blocks: ${totalBlocks}`);

  let lastProgressLog = Date.now();
  let retryCount = 0;
  const MAX_RETRIES = 5;

  for (let currentBlock = startBlock; currentBlock <= endBlock; ) {
    const toBlock = Math.min(currentBlock + BatchSize - 1, endBlock);
    try {
      const logs = await provider.getLogs({
        address: USDT_ADDRESS,
        fromBlock: currentBlock,
        toBlock: toBlock,
        topics: [id("Transfer(address,address,uint256)")],
      });

      for (const log of logs) {
        const from = `0x${log.topics[1].slice(26)}`;
        const to = `0x${log.topics[2].slice(26)}`;
          const amount = BigInt(log.data);
          console.log(from, to, amount);

        if (from.toLowerCase() === TARGET_ADDRESS.toLowerCase()) {
          balance -= amount;
        }

        if (to.toLowerCase() === TARGET_ADDRESS.toLowerCase()) {
          balance += amount;
        }
      }

      if (Date.now() - lastProgressLog > 5000) {
        const progress = formatProgress(currentBlock - startBlock, totalBlocks);
        console.log(
          `Progress: ${progress} | Current Block: ${currentBlock.toLocaleString()} | Balance: ${formatUnits(balance, 6)} USDT`,
        );
        lastProgressLog = Date.now();
      }

      currentBlock = toBlock + 1;
      retryCount = 0;
    } catch (error) {
      console.error(
        `Error processing blocks ${currentBlock} to ${toBlock}:`,
        error,
      );
      retryCount++;

      if (retryCount >= MAX_RETRIES) {
        throw new Error(
          `Failed after ${MAX_RETRIES} retries at block ${currentBlock}`,
        );
      }

      BatchSize = Math.max(Math.floor(BatchSize / 2), 100);
      console.log(
        `Reduced batch size to ${BatchSize}. Retrying in 5 seconds...`,
      );
      await sleep(5000);
      continue;
    }
  }

  return formatEther(balance);
};

const main = async () => {
  const currentBlock = await provider.getBlockNumber();
  const startBlock = 7_962_500;
  console.log(`Scanning from block ${startBlock} to block ${currentBlock}`);
  const start = Date.now();
  const balance = await getBalanceFromStart(startBlock, currentBlock);
  const end = Date.now();

  console.log(`${balance} USDT`);
  const timeTakenMs = end - start;
  const minutes = Math.floor(timeTakenMs / 60000);
  const seconds = ((timeTakenMs % 60000) / 1000).toFixed(2);
  console.log(`Time taken: ${minutes}m ${seconds}s`);

  const currentBalance = await getCurrentBalanceFromContract();

  console.log(`${currentBalance} USDT`);
};

main();
