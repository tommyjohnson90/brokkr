# Brokkr

Brokkr is a marketplace platform that connects designers with makers who can bring their designs to life. The platform streamlines the process of finding skilled makers with the right equipment, managing orders, and ensuring quality throughout the manufacturing process.

## Features

- **Design Marketplace**: Upload, discover, and purchase designs for physical products
- **Maker Matching**: AI-powered matching of designs with qualified makers
- **Order Management**: Track orders from purchase to delivery
- **Equipment Inventory**: Detailed equipment tracking for precise maker selection
- **Contest System**: Create and participate in design contests
- **Messaging System**: Built-in communication between designers, makers, and customers
- **Review System**: Multi-dimensional review structure
- **AI Integration**: AI-powered assistance throughout the platform

## Technology Stack

- **Frontend**: Next.js, React, TypeScript, Tailwind CSS
- **Backend**: Next.js API Routes, TypeScript, MCP Architecture
- **Database**: PostgreSQL with Supabase
- **Authentication**: Supabase Auth with JWT
- **AI Services**: Python FastAPI with Pydantic
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions

## MCP Architecture

The application uses a Model-Controller-Presenter (MCP) architecture to improve maintainability, testability, and scalability:

- **Models**: Handle data access and storage (Supabase integration)
- **Controllers**: Implement business logic and orchestrate operations
- **Presenters**: Format data for views and handle presentation logic

## Getting Started

### Prerequisites

- Node.js 20.x
- Docker and Docker Compose
- Supabase account
- GitHub account (for cloud builds)

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/tommyjohnson90/brokkr.git
   cd brokkr
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your Supabase credentials
   ```

4. Start the development server:
   ```bash
   npm run dev
   # or use Docker
   npm run docker:dev
   ```

### Cloud Builds and Deployment

1. Set up GitHub secrets:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `SUPABASE_JWT_SECRET`

2. Run cloud builds:
   ```bash
   # For staging environment (no push)
   npm run cloud:build
   
   # For production environment (with push)
   npm run cloud:build:prod
   ```

3. Deploy using cloud-built images:
   ```bash
   # Deploy staging environment
   npm run cloud:deploy:staging
   
   # Deploy production environment
   npm run cloud:deploy:prod
   ```

## Testing

```bash
# Run MCP tests
npm run test:mcp

# Run end-to-end tests
npm run test:e2e

# Run AI agent tests
npm run test:e2e:agents

# Run all tests in Docker
npm run docker:test
```

## Documentation

For more detailed documentation, see the following:

- [MCP Architecture Guide](docs/MCP_DOCUMENTATION.md)
- [Supabase Integration](docs/SUPABASE_STARTUP_GUIDE.md)
- [Docker Deployment Guide](docs/dev_environment_deployment.md)
- [AI Agent Documentation](pydantic-agents/README.md)

## License

This project is private and proprietary.

## Contributors

- Tommy Johnson