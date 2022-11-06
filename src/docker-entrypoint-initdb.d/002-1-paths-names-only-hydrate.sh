#!/usr/bin/env bash
# FYI: used to insert a CSV with name column only into paths table

## TODO: still need todo source-path-names-only
## ^ @see https://stackoverflow.com/questions/48019381/how-postgresql-copy-to-stdin-with-csv-do-on-conflic-do-update

set -e

THIS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
TABLE_DATA_FILE="$THIS_DIR/fixtures/source-path-names-only.csv"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  -- temp table
  create temp table paths_temp (
    name text not null,
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
  );

  COPY paths_temp (name)
  FROM '$TABLE_DATA_FILE'
  CSV
  HEADER
  ;

  insert into paths (name)
  select (name) from paths_temp
  on conflict do nothing;
EOSQL
