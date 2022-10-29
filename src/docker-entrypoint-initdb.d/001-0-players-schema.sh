#!/usr/bin/env bash

set -e

TABLE_NAME=players

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    callsign text PRIMARY KEY,
    email text NOT NULL UNIQUE,
    password text NOT NULL,
    first text,
    avatar text,
    about text,
    last text
  );

EOSQL
