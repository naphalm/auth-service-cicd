#!/bin/sh
echo "Running migrations..."

# Example: create users table if not exists
psql "$DATABASE_URL" <<'EOSQL'
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOSQL

echo "Migrations complete."
