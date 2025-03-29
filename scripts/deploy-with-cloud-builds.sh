#!/bin/bash

ENVIRONMENT=${1:-staging}

if [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "production" ] && [ "$ENVIRONMENT" != "development" ]; then
  echo "Error: Environment must be 'development', 'staging', or 'production'"
  exit 1
 fi

echo "Deploying $ENVIRONMENT environment using cloud-built images..."

# Determine Docker Compose file
if [ "$ENVIRONMENT" == "production" ]; then
  COMPOSE_FILE="docker-compose.prod.yml"
elif [ "$ENVIRONMENT" == "staging" ]; then
  COMPOSE_FILE="docker-compose.staging.yml"
else
  COMPOSE_FILE="docker-compose.yml"
fi

# Pull the latest images
echo "Pulling the latest images from GitHub Container Registry..."
docker pull ghcr.io/tommyjohnson90/brokkr/app:$ENVIRONMENT
docker pull ghcr.io/tommyjohnson90/brokkr/db-init:$ENVIRONMENT
docker pull ghcr.io/tommyjohnson90/brokkr/pydantic-agents:$ENVIRONMENT

# Only pull monitoring image for production
if [ "$ENVIRONMENT" == "production" ]; then
  docker pull ghcr.io/tommyjohnson90/brokkr/monitoring:$ENVIRONMENT
fi

# Ensure environment variables are set
if [ -z "$NEXT_PUBLIC_SUPABASE_URL" ] || [ -z "$NEXT_PUBLIC_SUPABASE_ANON_KEY" ] || [ -z "$SUPABASE_SERVICE_ROLE_KEY" ] || [ -z "$SUPABASE_JWT_SECRET" ]; then
  echo "Error: Required environment variables are not set. Please set the following variables:"
  echo "- NEXT_PUBLIC_SUPABASE_URL"
  echo "- NEXT_PUBLIC_SUPABASE_ANON_KEY"
  echo "- SUPABASE_SERVICE_ROLE_KEY"
  echo "- SUPABASE_JWT_SECRET"
  exit 1
fi

# Deploy with Docker Compose
echo "Deploying with Docker Compose using $COMPOSE_FILE..."
docker-compose -f $COMPOSE_FILE down
docker-compose -f $COMPOSE_FILE up -d

echo "Deployment complete. Services are starting up..."
docker-compose -f $COMPOSE_FILE ps

echo "To see logs, run: docker-compose -f $COMPOSE_FILE logs -f"