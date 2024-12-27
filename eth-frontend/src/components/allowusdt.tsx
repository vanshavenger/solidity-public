import { useWriteContract } from 'wagmi'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { ABI } from '@/abi'
import { USDT_ADDRESS } from '@/constants'
import { motion } from 'framer-motion'
import { Check, Lock, AlertCircle } from 'lucide-react'
import { useState } from 'react'
import { parseUnits } from 'viem'

export function AllowUSDT() {
  const { writeContract, isError, error, isSuccess } = useWriteContract()
  const [approvedAddress, setApprovedAddress] = useState<string>('')
  const [approvedValue, setApprovedValue] = useState<string>('')

  async function submit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    try {
      const bigIntValue = parseUnits(approvedValue, 6)
      writeContract({
        address: USDT_ADDRESS,
        abi: ABI,
        functionName: 'approve',
        args: [approvedAddress as `0x${string}`, BigInt(bigIntValue)],
      })
    } catch (error) {
      console.error('Error approving USDT:', error)
    }
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      className='bg-gradient-to-r from-yellow-400 to-orange-500 p-6 rounded-lg shadow-md'
    >
      <div className='flex items-center text-white mb-4'>
        <Lock className='w-6 h-6 mr-2' />
        <h3 className='text-xl font-semibold'>Approve USDT</h3>
      </div>
      <form onSubmit={submit} className='space-y-4'>
        <div>
          <label
            htmlFor='address'
            className='block text-sm font-medium text-white mb-1'
          >
            Address to Approve
          </label>
          <Input
            id='address'
            name='address'
            placeholder='0x...'
            required
            value={approvedAddress}
            onChange={(e) => setApprovedAddress(e.target.value)}
            className='w-full p-2 rounded-md border border-yellow-300 focus:outline-none focus:ring-2 focus:ring-yellow-500 bg-white text-gray-800'
          />
        </div>
        <div>
          <label
            htmlFor='value'
            className='block text-sm font-medium text-white mb-1'
          >
            Amount to Approve (USDT)
          </label>
          <Input
            id='value'
            name='value'
            type='number'
            step='0.000001'
            placeholder='100.000000'
            required
            value={approvedValue}
            onChange={(e) => setApprovedValue(e.target.value)}
            className='w-full p-2 rounded-md border border-yellow-300 focus:outline-none focus:ring-2 focus:ring-yellow-500 bg-white text-gray-800'
          />
        </div>
        <Button
          type='submit'
          className='w-full bg-white text-yellow-600 hover:bg-yellow-100 transition duration-200 flex items-center justify-center'
        >
          {isSuccess ? (
            <Check className='w-5 h-5 mr-2' />
          ) : (
            <Lock className='w-5 h-5 mr-2' />
          )}
          {isSuccess ? 'Approved' : 'Approve USDT'}
        </Button>
      </form>
      {isError && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className='mt-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-md flex items-start'
        >
          <AlertCircle className='w-5 h-5 mr-2 flex-shrink-0 mt-0.5' />
          <span className='text-sm'>
            Error:{' '}
            {error?.message || 'Failed to approve USDT. Please try again.'}
          </span>
        </motion.div>
      )}
      {isSuccess && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className='mt-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded-md flex items-start'
        >
          <Check className='w-5 h-5 mr-2 flex-shrink-0 mt-0.5' />
          <span className='text-sm'>
            Successfully approved {approvedValue} USDT for address:{' '}
            {approvedAddress}
          </span>
        </motion.div>
      )}
    </motion.div>
  )
}
