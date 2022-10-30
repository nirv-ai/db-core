#!/usr/bin/env bash

set -e

TABLE_NAME=players_paths
TABLE_COMMENT='junction table between players and paths'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    player_callsign TEXT REFERENCES nirvai.players (callsign) ON UPDATE CASCADE ON DELETE CASCADE,
    paths_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT players_paths_pkey PRIMARY KEY (player_callsign, paths_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
EOSQL
