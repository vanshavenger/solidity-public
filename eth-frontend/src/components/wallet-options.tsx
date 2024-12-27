import { useConnect } from 'wagmi'
import { Button } from '@/components/ui/button'
import { motion } from 'motion/react'
import { Wallet, Coins } from 'lucide-react'

export function WalletOptions() {
  const { connectors, connect } = useConnect()

  return (
    <div className='flex justify-center items-center min-h-screen'>
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className='bg-white p-8 rounded-2xl shadow-2xl w-full max-w-md'
      >
        <div className='flex items-center justify-center mb-6'>
          <Coins className='w-12 h-12 text-indigo-600 mr-2' />
          <h2 className='text-3xl font-bold text-gray-800'>Connect Wallet</h2>
        </div>
        <div className='space-y-4'>
          {connectors.map((connector) => (
            <motion.div
              key={connector.uid}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <Button
                onClick={() => connect({ connector })}
                className='w-full py-3 px-4 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg transition duration-200 flex items-center justify-center'
              >
                <Wallet className='w-5 h-5 mr-2' />
                Connect via {connector.name}
              </Button>
            </motion.div>
          ))}
        </div>
      </motion.div>
    </div>
  )
}
