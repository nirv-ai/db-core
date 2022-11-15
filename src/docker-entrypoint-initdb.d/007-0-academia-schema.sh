#!/usr/bin/env bash

set -e

TABLE_NAME=academia
TABLE_COMMENT='recommended level of education before embarking on path'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    name text PRIMARY KEY,
    created_by text DEFAULT 'nirvai',
    display_name text DEFAULT ''
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'academia name, once created CANNOT be changed';
  comment on column $TABLE_NAME.created_by is 'player that created the academia, nirvai by default';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing academia.name';

EOSQL
