#!/usr/bin/env bash

set -e

TABLE_NAME=paths_strategies_players
TABLE_COMMENT='junction table between paths, players and strategies'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    player_callsign TEXT REFERENCES nirvai.players (callsign) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    strategy_name TEXT REFERENCES nirvai.paths_strategies (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    CONSTRAINT paths_strategies_players_pkey PRIMARY KEY (path_name, strategy_name, player_callsign)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_strategies_players_player_callsign_index on nirvai.paths_strategies_players (player_callsign) INCLUDE (player_callsign);
  CREATE INDEX paths_strategies_players_path_name_index on nirvai.paths_strategies_players (path_name) INCLUDE (path_name);
  CREATE INDEX paths_strategies_players_strategy_name_index on nirvai.paths_strategies_players (strategy_name) INCLUDE (strategy_name);
EOSQL
