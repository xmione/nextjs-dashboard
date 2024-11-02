import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  // output: 'export',
  experimental: {
    ppr: 'incremental',
    serverActions: {
      allowedOrigins: ["localhost:3000", "potential-winner-5g4x6jq7wv7hvqwr-3000.app.github.dev"],
    },
  },
};

export default nextConfig;
