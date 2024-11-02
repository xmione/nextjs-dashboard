import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  // output: 'export',
  experimental: {
    ppr: 'incremental',
    serverActions: {
      allowedOrigins: ["localhost:3000"],
    },
  },
};

export default nextConfig;
