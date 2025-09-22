/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable experimental features
  experimental: {
    // Enable server actions (useful for forms)
    serverActions: true,
  },

  // Image optimization configuration
  images: {
    formats: ['image/webp', 'image/avif'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
    minimumCacheTTL: 60,
    dangerouslyAllowSVG: true,
    contentSecurityPolicy: "default-src 'self'; script-src 'none'; sandbox;",
    // Add external image domains if needed
    domains: [
      // 'images.unsplash.com',
      // 'assets.zyrosite.com',
    ],
  },

  // Compiler options
  compiler: {
    // Remove console logs in production
    removeConsole: process.env.NODE_ENV === 'production',
  },

  // Headers for security and performance
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          // Security headers
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on'
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block'
          },
          {
            key: 'X-Frame-Options',
            value: 'SAMEORIGIN'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin'
          },
          // Performance headers
          {
            key: 'X-Powered-By',
            value: 'Starlane Global'
          }
        ],
      },
      // Cache static assets
      {
        source: '/images/(.*)',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable'
          }
        ],
      },
      {
        source: '/icons/(.*)',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable'
          }
        ],
      }
    ];
  },

  // Redirect configuration
  async redirects() {
    return [
      // Example redirects
      // {
      //   source: '/old-path',
      //   destination: '/new-path',
      //   permanent: true,
      // },
    ];
  },

  // Rewrite configuration for clean URLs
  async rewrites() {
    return [
      // API routes rewrites if needed
      // {
      //   source: '/api/contact',
      //   destination: '/api/contact/route',
      // },
    ];
  },

  // Environment variables validation
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },

  // Bundle analyzer (uncomment to analyze bundle size)
  // webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
  //   if (process.env.ANALYZE === 'true') {
  //     const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');
  //     config.plugins.push(
  //       new BundleAnalyzerPlugin({
  //         analyzerMode: 'server',
  //         analyzerPort: isServer ? 8888 : 8889,
  //         openAnalyzer: true,
  //       })
  //     );
  //   }
  //   return config;
  // },

  // Disable powered by header
  poweredByHeader: false,

  // Enable gzip compression
  compress: true,

  // Generate ETags for pages
  generateEtags: true,

  // Configure page extensions
  pageExtensions: ['ts', 'tsx', 'js', 'jsx'],

  // Strict mode for React
  reactStrictMode: true,

  // SWC minification (faster than Terser)
  swcMinify: true,

  // Trailing slash configuration
  trailingSlash: false,

  // Output configuration for deployment
  output: 'standalone', // Use 'export' for static export
};

module.exports = nextConfig;