import { ABI } from '@/abi'
import { USDT_ADDRESS } from '@/constants'
import { useAccount, useReadContract } from 'wagmi'
import { motion } from 'motion/react'
import { Wallet } from 'lucide-react'

export function TotalBalance() {
  const { address } = useAccount()
  const { data, isLoading, isError, error } = useReadContract({
    address: USDT_ADDRESS,
    abi: ABI,
    functionName: 'balanceOf',
    args: address ? [address as `0x${string}`] : undefined,
  })

  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.5 }}
      className='bg-gradient-to-r from-green-500 to-teal-600 p-4 rounded-lg shadow-md'
    >
      <div className='flex items-center text-white'>
        <Wallet className='w-6 h-6 mr-2' />
        <h3 className='text-lg font-semibold'>Your Balance</h3>
      </div>
      {isLoading ? (
        <div className='text-white mt-2'>Loading...</div>
      ) : isError ? (
        <div className='text-red-300 mt-2'>Error: {error?.message}</div>
      ) : (
        <div className='text-2xl font-bold text-white mt-2'>
          {data?.toString() ?? '0'}
        </div>
      )}
    </motion.div>
  )
}
