import { useAccount, WagmiProvider } from 'wagmi'
import { config } from '@/config'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { Account } from '@/components/account'
import { WalletOptions } from '@/components/wallet-options'

const queryClient = new QueryClient()

function ConnectWallet() {
  const { isConnected } = useAccount()
  return isConnected ? <Account /> : <WalletOptions />
}

function App() {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <main className='flex-grow'>
          <ConnectWallet />
        </main>
      </QueryClientProvider>
    </WagmiProvider>
  )
}

export default App
