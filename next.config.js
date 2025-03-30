/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['localhost', 'ycjyauzyuvdkilqvyibc.supabase.co'],
  },
  output: 'standalone',
};

module.exports = nextConfig;