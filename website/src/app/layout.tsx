import type { Metadata } from 'next';
import { Inter, Montserrat, Playfair_Display } from 'next/font/google';
import './globals.css';
import { AuthProvider } from '@/contexts/AuthContext';

// Fonts configuration
const inter = Inter({ 
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
});

const montserrat = Montserrat({ 
  subsets: ['latin'],
  variable: '--font-montserrat',
  display: 'swap',
});

const playfair = Playfair_Display({ 
  subsets: ['latin'],
  variable: '--font-playfair',
  display: 'swap',
});

export const metadata: Metadata = {
  title: 'Starlane Global | Luxury Services & Lifestyle Management',
  description: 'Experience the pinnacle of life with Starlane Global. Premium luxury services, bespoke experiences, and lifestyle management that celebrates diversity and redefines luxury.',
  keywords: [
    'luxury services',
    'concierge services', 
    'lifestyle management',
    'private jets',
    'luxury real estate',
    'exclusive events',
    'diversity in luxury',
    'premium experiences',
    'global luxury',
    'bespoke services'
  ],
  authors: [{ name: 'Starlane Global', url: 'https://starlaneglobal.com' }],
  creator: 'Starlane Global',
  publisher: 'Starlane Global',
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://starlaneglobal.com',
    siteName: 'Starlane Global',
    title: 'Starlane Global | Luxury Services & Lifestyle Management',
    description: 'Experience the pinnacle of life with Starlane Global. Premium luxury services that celebrate diversity and redefine luxury.',
    images: [
      {
        url: '/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'Starlane Global - Luxury Services',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Starlane Global | Luxury Services & Lifestyle Management',
    description: 'Experience the pinnacle of life with Starlane Global. Premium luxury services that celebrate diversity and redefine luxury.',
    images: ['/og-image.jpg'],
    creator: '@starlaneglobal',
  },
  viewport: {
    width: 'device-width',
    initialScale: 1,
    maximumScale: 5,
  },
  verification: {
    google: 'your-google-verification-code',
  },
  alternates: {
    canonical: 'https://starlaneglobal.com',
  },
  category: 'business',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html 
      lang="en" 
      className={`${inter.variable} ${montserrat.variable} ${playfair.variable}`}
    >
      <head>
        {/* Favicon */}
        <link rel="icon" href="/favicon.ico" sizes="any" />
        <link rel="icon" href="/favicon.svg" type="image/svg+xml" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        
        {/* Theme color */}
        <meta name="theme-color" content="#1e293b" />
        <meta name="msapplication-TileColor" content="#1e293b" />
        
        {/* Preconnect to external domains */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        
        {/* Schema.org structured data */}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "Organization",
              "name": "Starlane Global",
              "description": "Premium luxury services and lifestyle management company operating globally",
              "url": "https://starlaneglobal.com",
              "logo": "https://starlaneglobal.com/logo.png",
              "contactPoint": {
                "@type": "ContactPoint",
                "telephone": "+44-7934-858-048",
                "contactType": "customer service",
                "email": "contact@starlaneglobal.com",
                "availableLanguage": ["English", "French"]
              },
              "address": {
                "@type": "PostalAddress",
                "streetAddress": "45 Fitzroy Street",
                "addressLocality": "London",
                "postalCode": "W1T 6EB",
                "addressCountry": "GB"
              },
              "sameAs": [
                "https://www.linkedin.com/company/starlaneglobal",
                "https://twitter.com/starlaneglobal",
                "https://www.instagram.com/starlaneglobal"
              ],
              "serviceArea": {
                "@type": "Place",
                "name": "Global"
              }
            })
          }}
        />
      </head>
      <body className={`${inter.className} antialiased`}>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  );
}