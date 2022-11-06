#!/usr/bin/env bash

set -e

TABLE_NAME=paths
TABLE_COMMENT='paths define ovarching ways of life'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    name text PRIMARY KEY,
    display_name text DEFAULT '',
    about text DEFAULT ''
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'paths name, once created CANNOT be changed';
  comment on column $TABLE_NAME.about is 'description of path';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing paths.name';

EOSQL
