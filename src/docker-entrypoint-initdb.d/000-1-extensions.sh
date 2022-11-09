#!/usr/bin/env bash

set -e

# @see https://www.postgresql.org/docs/current/sql-createextension.html
# @see https://www.postgresql.org/docs/current/pgcrypto.html

# TODO: move extensions to a separate schema

# TODO: https://github.com/zombodb/zombodb
# todo: https://github.com/reorg/pg_repack
# todo: https://pgxn.org/

# FYI
## good review: https://severalnines.com/blog/my-favorite-postgresql-extensions-part-one/
## inspect shared libraries: sql`show shared_preload_libraries`;
### see the provided postgresql.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  -- CREATE EXTENSION pg_partman
  CREATE EXTENSION IF NOT EXISTS adminpack SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS bloom SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS citext SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS dict_int SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS file_fdw SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS hstore SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS pg_stat_statements SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS plv8 SCHEMA $DEFAULT_DB CASCADE;
  CREATE EXTENSION IF NOT EXISTS postgres_fdw SCHEMA $DEFAULT_DB CASCADE;
EOSQL
