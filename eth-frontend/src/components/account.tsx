import { useAccount, useDisconnect, useEnsAvatar, useEnsName } from 'wagmi'
import { Button } from '@/components/ui/button'
import { TotalSupply } from '@/components/total-supply'
import { TotalBalance } from '@/components/balanceof'
import { AllowUSDT } from '@/components/allowusdt'
import { motion } from 'motion/react'
import { LogOut, User } from 'lucide-react'

export function Account() {
  const { address } = useAccount()
  const { disconnect } = useDisconnect()
  const { data: ensName } = useEnsName({ address })
  const { data: ensAvatar } = useEnsAvatar({ name: ensName! })

  return (
    <div className='flex justify-center items-center min-h-screen'>
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className='bg-white p-8 rounded-2xl shadow-2xl w-full max-w-md'
      >
        <div className='flex flex-col items-center space-y-6'>
          {ensAvatar ? (
            <img
              alt='ENS Avatar'
              src={ensAvatar}
              className='w-24 h-24 rounded-full border-4 border-indigo-500 shadow-lg'
            />
          ) : (
            <User className='w-24 h-24 text-indigo-500' />
          )}
          {address && (
            <div className='text-center'>
              <h2 className='text-2xl font-bold text-gray-800'>
                {ensName || 'Ethereum Account'}
              </h2>
              <p className='text-sm text-gray-600 mt-1 break-all bg-gray-100 p-2 rounded-lg'>
                {address}
              </p>
            </div>
          )}
          <div className='w-full space-y-4'>
            <TotalSupply />
            <TotalBalance />
            <AllowUSDT />
          </div>
          <Button
            variant={'destructive'}
            onClick={() => disconnect()}
            className='mt-4 py-2 px-4 transition duration-200 flex items-center'
          >
            <LogOut className='w-5 h-5 mr-2' />
            Disconnect
          </Button>
        </div>
      </motion.div>
    </div>
  )
}
