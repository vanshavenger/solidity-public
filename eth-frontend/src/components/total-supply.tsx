import { useReadContract } from 'wagmi'
import { ABI } from '@/abi'
import { USDT_ADDRESS } from '@/constants'
import { motion } from 'motion/react'
import { Coins } from 'lucide-react'

export function TotalSupply() {
  const { data, isError, isLoading, error } = useReadContract({
    address: USDT_ADDRESS,
    abi: ABI,
    functionName: 'totalSupply',
  })

  return (
    <motion.div
      initial={{ opacity: 0, x: -20 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.5 }}
      className='bg-gradient-to-r from-blue-500 to-indigo-600 p-4 rounded-lg shadow-md'
    >
      <div className='flex items-center text-white'>
        <Coins className='w-6 h-6 mr-2' />
        <h3 className='text-lg font-semibold'>Total Supply</h3>
      </div>
      {isLoading ? (
        <div className='text-white mt-2'>Loading...</div>
      ) : isError ? (
        <div className='text-red-300 mt-2'>Error: {error?.message}</div>
      ) : (
        <div className='text-2xl font-bold text-white mt-2'>
          {data?.toString()}
        </div>
      )}
    </motion.div>
  )
}
