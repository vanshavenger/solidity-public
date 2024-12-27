import { http, createConfig, injected } from 'wagmi'
import { mainnet, sepolia } from 'wagmi/chains'
import { metaMask } from 'wagmi/connectors'

console.log(import.meta.env.VITE_MAINNET_URL)
console.log(import.meta.env.VITE_SEPOLIA_URL)

export const config = createConfig({
  chains: [mainnet, sepolia],
  connectors: [metaMask(), injected()],
  transports: {
    [mainnet.id]: http(import.meta.env.VITE_MAINNET_URL),
    [sepolia.id]: http(import.meta.env.VITE_SEPOLIA_URL),
  },
})
