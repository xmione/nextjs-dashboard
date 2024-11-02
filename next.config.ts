import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  // output: 'export',
  experimental: {
    ppr: 'incremental',
    serverActions: {
      allowedOrigins: ['https://nextjs-dashboard-mauve-six-93.vercel.app/'],
    },
  },
};

export default nextConfig;
