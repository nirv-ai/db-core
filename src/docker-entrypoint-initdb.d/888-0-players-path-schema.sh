#!/usr/bin/env bash

set -e

TABLE_NAME=players_paths
TABLE_COMMENT='junction table between players and paths'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    player_callsign TEXT REFERENCES nirvai.players (callsign) ON UPDATE CASCADE ON DELETE CASCADE,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT players_paths_pkey PRIMARY KEY (player_callsign, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX players_paths_player_callsign_index on nirvai.players_paths (player_callsign) INCLUDE (path_name);
  CREATE INDEX players_paths_path_name_index on nirvai.players_paths (path_name) INCLUDE (player_callsign);
EOSQL
