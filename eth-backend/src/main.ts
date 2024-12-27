export interface WorkerData {
  startBlock: number;
  endBlock: number;
  batchSize: number;
  targetAddress: string;
  usdtAddress: string;
  rpcUrl: string;
  workerId: number;
}

export interface ProgressMessage {
  type: "progress";
  workerId: number;
  progress: string;
}

export interface ResultMessage {
  type: "result";
  balance: string;
}

export type WorkerMessage = ProgressMessage | ResultMessage;

import { Worker } from "worker_threads";
import { JsonRpcProvider, formatUnits } from "ethers";
import * as dotenv from "dotenv";
import path from "path";
import { TARGET_ADDRESS, USDT_ADDRESS } from "./constants";

dotenv.config();

const BATCH_SIZE = 2000;
const NUM_WORKERS = 7;

const MAINNET_URL = process.env.MAINNET_URL;

if (!TARGET_ADDRESS || !USDT_ADDRESS || !MAINNET_URL) {
  throw new Error("Missing required environment variables");
}

const provider = new JsonRpcProvider(MAINNET_URL);

function splitBlockRange(
  startBlock: number,
  endBlock: number,
  numWorkers: number,
): Array<{ startBlock: number; endBlock: number }> {
  const totalBlocks = endBlock - startBlock;
  const blocksPerWorker = Math.floor(totalBlocks / numWorkers);
  const ranges = [];

  for (let i = 0; i < numWorkers; i++) {
    const workerStartBlock = startBlock + i * blocksPerWorker;
    const workerEndBlock =
      i === numWorkers - 1 ? endBlock : workerStartBlock + blocksPerWorker - 1;
    ranges.push({ startBlock: workerStartBlock, endBlock: workerEndBlock });
  }

  return ranges;
}


function createWorker(workerData: WorkerData): Promise<bigint> {
  return new Promise((resolve, reject) => {
    const worker = new Worker(path.join(__dirname, "worker.js"), {
      workerData,
    });

    worker.on("message", (message: WorkerMessage) => {
      if (message.type === "progress") {
        console.log(`Worker ${message.workerId}: ${message.progress}`);
      } else if (message.type === "result") {
        resolve(BigInt(message.balance));
      }
    });

    worker.on("error", reject);
    worker.on("exit", (code) => {
      if (code !== 0) {
        reject(new Error(`Worker stopped with exit code ${code}`));
      }
    });
  });
}

async function main() {
  const currentBlock = await provider.getBlockNumber();
  const startBlock = 8_037_500;
  console.log(`Scanning from block ${startBlock} to block ${currentBlock}`);

  const start = Date.now();
  const blockRanges = splitBlockRange(startBlock, currentBlock, NUM_WORKERS);

  const workerPromises = blockRanges.map((range, index) => {
    const workerData: WorkerData = {
      startBlock: range.startBlock,
      endBlock: range.endBlock,
      batchSize: BATCH_SIZE,
      targetAddress: TARGET_ADDRESS,
      usdtAddress: USDT_ADDRESS,
      rpcUrl: MAINNET_URL as string,
      workerId: index + 1,
    };

    return createWorker(workerData);
  });

  try {
    const balances = await Promise.all(workerPromises);
    const totalBalance = balances.reduce((a, b) => a + b, 0n);

    const end = Date.now();
    console.log(`Total Balance: ${formatUnits(totalBalance, 6)} USDT`);

    const timeTakenMs = end - start;
    const minutes = Math.floor(timeTakenMs / 60000);
    const seconds = ((timeTakenMs % 60000) / 1000).toFixed(2);
    console.log(`Time taken: ${minutes}m ${seconds}s`);
  } catch (error) {
    console.error("Error in worker:", error);
    process.exit(1);
  }
}

main().catch(console.error);
