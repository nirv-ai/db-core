#!/usr/bin/env bash

## TODO: still need todo source-path-names-only
## ^ @see https://stackoverflow.com/questions/48019381/how-postgresql-copy-to-stdin-with-csv-do-on-conflic-do-update
## upon errors (as usual) I would totally recommend pgloader
## ^ to first get data into the db, then you can export for programmatic hydration
## @see https://pgloader.readthedocs.io/en/latest/quickstart.html
## @see https://www.postgresql.org/docs/current/sql-copy.html
## sudo apt install pgloader
## pgloader paths_csv_cmds.load

set -e

TABLE_NAME=players
THIS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
TABLE_DATA_FILE="$THIS_DIR/fixtures/source-players.csv"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  COPY $TABLE_NAME (callsign, email,password,first, last,avatar,about)
  FROM '$TABLE_DATA_FILE'
  CSV
  HEADER
  ;
EOSQL
