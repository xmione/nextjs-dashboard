import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  experimental: {
    ppr: 'incremental',
    serverActions: {
      allowedOrigins: ['https://nextjs-dashboard-mauve-six-93.vercel.app/'],
    },
  },
};

export default nextConfig;
