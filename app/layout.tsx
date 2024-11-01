import '@/app/ui/global.css';
import { inter } from '@/app/ui/fonts';
import type { Metadata } from 'next';
import Head from 'next/head'; // Import Head from next/head

export const metadata: Metadata = {
  title: {
    template: '%s | Acme Dashboard',
    default: 'Acme Dashboard',
  },
  description: 'The official Next.js Learn Dashboard built with App Router.',
  metadataBase: new URL('https://next-learn-dashboard.vercel.sh'),
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <Head>
        {/* Conditionally include the script for development */}
        {process.env.NODE_ENV === 'development' && (
          <script src="http://localhost:8097" />
        )}
      </Head>
      <body className={`${inter.className} antialiased`}>{children}</body>
    </html>
  );
}
