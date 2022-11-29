#!/usr/bin/env bash

set -e

TABLE_NAME=academias
TABLE_COMMENT='recommended level of education before embarking on path'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    name text PRIMARY KEY collate anymatch,
    about text DEFAULT '' collate anymatch,
    created_by text DEFAULT 'nirvai' collate anymatch,
    display_name text DEFAULT '' collate anymatch
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'academia name, once created CANNOT be changed';
  comment on column $TABLE_NAME.about is 'description of academia';
  comment on column $TABLE_NAME.created_by is 'player that created the academia, nirvai by default';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing academia.name';

EOSQL
