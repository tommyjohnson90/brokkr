#!/bin/bash

# This script initializes the database by running SQL scripts in order

# Set default host if not provided
POSTGRES_HOST=${POSTGRES_HOST:-"localhost"}

# Wait for PostgreSQL to be ready
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q'; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is up - executing SQL scripts"

# Execute SQL files in order
SQL_FILES=(
  /docker-entrypoint-initdb.d/setup-exec-sql.sql
  /docker-entrypoint-initdb.d/core-functions-simple.sql
  /docker-entrypoint-initdb.d/basic-tables-improved.sql
  /docker-entrypoint-initdb.d/missing-tables-simple-improved.sql
  /docker-entrypoint-initdb.d/create-units-table-improved.sql
  /docker-entrypoint-initdb.d/equipment-subtypes-and-specs-improved.sql
  /docker-entrypoint-initdb.d/enhanced-orders-improved.sql
  /docker-entrypoint-initdb.d/messaging-system-improved.sql
  /docker-entrypoint-initdb.d/contest-system-improved.sql
  /docker-entrypoint-initdb.d/ai-integration-improved.sql
  /docker-entrypoint-initdb.d/security-compliance-improved.sql
  /docker-entrypoint-initdb.d/api-integration-improved.sql
  /docker-entrypoint-initdb.d/design-versioning-migration-fixed.sql
)

for sql_file in "${SQL_FILES[@]}"; do
  if [ -f "$sql_file" ]; then
    echo "Executing SQL file: $sql_file"
    PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$sql_file"
  else
    echo "Warning: SQL file not found: $sql_file"
  fi
done

echo "Database initialization complete!"