#!/usr/bin/env bash

set -e

# @see https://www.postgresql.org/docs/current/sql-createextension.html
# @see https://www.postgresql.org/docs/current/pgcrypto.html

# this only enables the extension for $POSTGRES_USER
## to enable for the others, grant them priveleges to the functions

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA $DEFAULT_DB CASCADE;
EOSQL
