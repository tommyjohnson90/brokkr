#!/bin/bash

# Wait for PostgreSQL to be ready
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q'; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is up - executing SQL scripts"

# Execute SQL files in alphabetical order
for sql_file in /docker-entrypoint-initdb.d/*.sql; do
  if [ -f "$sql_file" ]; then
    echo "Executing SQL file: $sql_file"
    PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$sql_file"
  fi
done

echo "Database initialization complete!"