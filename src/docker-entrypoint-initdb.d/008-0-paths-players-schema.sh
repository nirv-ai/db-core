#!/usr/bin/env bash

set -e

TABLE_NAME=paths_players
TABLE_COMMENT='junction table between paths and players'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    player_callsign TEXT REFERENCES nirvai.players (callsign) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,

    CONSTRAINT paths_players_pkey PRIMARY KEY (player_callsign, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_players_player_callsign_index on nirvai.paths_players (player_callsign) INCLUDE (player_callsign);
  CREATE INDEX paths_players_path_name_index on nirvai.paths_players (path_name) INCLUDE (path_name);
EOSQL
