import { parentPort, workerData } from "worker_threads";
import { JsonRpcProvider, formatUnits, ethers } from "ethers";
import { WorkerData, WorkerMessage } from "./main";

if (!parentPort) {
  throw new Error("This file must be run as a worker thread");
}

const provider = new JsonRpcProvider(workerData.rpcUrl);

async function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function processBlockRange(): Promise<bigint> {
  let balance = 0n;
  const {
    startBlock,
    endBlock,
    batchSize,
    targetAddress,
    usdtAddress,
    workerId,
  } = workerData as WorkerData;
  const totalBlocks = endBlock - startBlock;

  let lastProgressLog = Date.now();
  let retryCount = 0;
  const MAX_RETRIES = 5;
  let currentBatchSize = batchSize;

  for (let currentBlock = startBlock; currentBlock <= endBlock; ) {
    const toBlock = Math.min(currentBlock + currentBatchSize - 1, endBlock);

    try {
      const logs = await provider.getLogs({
        address: usdtAddress,
        fromBlock: currentBlock,
        toBlock: toBlock,
        topics: [ethers.id("Transfer(address,address,uint256)")],
      });

      for (const log of logs) {
        const from = `0x${log.topics[1].slice(26)}`;
        const to = `0x${log.topics[2].slice(26)}`;
        const amount = BigInt(log.data);

        if (from.toLowerCase() === targetAddress.toLowerCase()) {
          balance -= amount;
        }
        if (to.toLowerCase() === targetAddress.toLowerCase()) {
          balance += amount;
        }
      }

      if (Date.now() - lastProgressLog > 5000) {
        const progress = formatProgress(currentBlock - startBlock, totalBlocks);
        const message: WorkerMessage = {
          type: "progress",
          workerId,
          progress: `${progress} | Current Block: ${currentBlock.toLocaleString()} | Balance: ${formatUnits(balance, 6)} USDT`,
        };
        parentPort!.postMessage(message);
        lastProgressLog = Date.now();
      }

      currentBlock = toBlock + 1;
      retryCount = 0;
    } catch (error) {
      console.error(
        `Worker ${workerId} error processing blocks ${currentBlock} to ${toBlock}:`,
        error,
      );
      retryCount++;

      if (retryCount >= MAX_RETRIES) {
        throw new Error(
          `Worker ${workerId} failed after ${MAX_RETRIES} retries at block ${currentBlock}`,
        );
      }

      currentBatchSize = Math.max(Math.floor(currentBatchSize / 2), 100);
      console.log(
        `Worker ${workerId}: Reduced batch size to ${currentBatchSize}. Retrying in 5 seconds...`,
      );
      await sleep(5000);
      continue;
    }
  }

  return balance;
}

function formatProgress(current: number, total: number): string {
  const percentage = ((current / total) * 100).toFixed(2);
  const progress = "#"
    .repeat(Math.floor((current / total) * 20))
    .padEnd(20, "-");
  return `[${progress}] ${percentage}%`;
}

processBlockRange()
  .then((balance) => {
    if (parentPort) {
      const message: WorkerMessage = {
        type: "result",
        balance: balance.toString(),
      };
      parentPort.postMessage(message);
    }
  })
  .catch((error) => {
    throw error;
  });
