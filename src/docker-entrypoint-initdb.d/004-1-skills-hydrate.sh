#!/usr/bin/env bash

## upon errors (as usual) I would totally recommend pgloader
## ^ to first get data into the db, then you can export for programmatic hydration
## @see https://pgloader.readthedocs.io/en/latest/quickstart.html
## sudo apt install pgloader
## pgloader paths_csv_cmds.load

set -e

TABLE_NAME=skills
THIS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
TABLE_DATA_FILE="$THIS_DIR/fixtures/source-actions.csv"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  COPY $TABLE_NAME (name)
  FROM '$TABLE_DATA_FILE'
  CSV
  HEADER
  ;
EOSQL
