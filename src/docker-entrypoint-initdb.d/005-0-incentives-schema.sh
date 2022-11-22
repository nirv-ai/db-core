#!/usr/bin/env bash

set -e

TABLE_NAME=incentives
TABLE_COMMENT='incentives are motivations for joining a path'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    name text PRIMARY KEY collate anymatch,
    created_by text DEFAULT 'nirvai' collate anymatch,
    about text DEFAULT '',
    display_name text DEFAULT ''
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'incentives name, once created CANNOT be changed';
  comment on column $TABLE_NAME.about is 'description of incentive';
  comment on column $TABLE_NAME.created_by is 'player that created the incentive, nirvai by default';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing incentives.name';

EOSQL
