#!/usr/bin/env bash

set -e

TABLE_NAME=paths_players
TABLE_COMMENT='junction table between paths and players'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    player_callsign TEXT REFERENCES nirvai.players (callsign) ON UPDATE CASCADE ON DELETE CASCADE,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT paths_players_pkey PRIMARY KEY (player_callsign, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_players_player_callsign_index on nirvai.paths_players (player_callsign) INCLUDE (player_callsign);
  CREATE INDEX paths_players_path_name_index on nirvai.paths_players (path_name) INCLUDE (path_name);
EOSQL
