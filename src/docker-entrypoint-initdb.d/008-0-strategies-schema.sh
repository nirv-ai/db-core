#!/usr/bin/env bash

set -e

TABLE_NAME=strategies
TABLE_COMMENT='strategies enable players to customize paths'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    about text DEFAULT '',
    name text NOT NULL UNIQUE,
    created_by text references players(callsign),
    path text references paths(name),
    display_name text DEFAULT '',
    UNIQUE (name, path)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'strategies name, once created CANNOT be changed';
  comment on column $TABLE_NAME.about is 'description of strategy';
  comment on column $TABLE_NAME.created_by is 'player that created the strategy, nirvai by default';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing strategies.name';

EOSQL
