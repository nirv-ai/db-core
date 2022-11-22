#!/usr/bin/env bash

set -e

TABLE_NAME=paths_strategies_academias
TABLE_COMMENT='junction table between paths, strategies and academias'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT references nirvai.paths (name) on UPDATE CASCADE ON DELETE CASCADE,
    academia_name TEXT REFERENCES nirvai.academias (name) ON UPDATE CASCADE ON DELETE CASCADE,
    strategy_name TEXT references nirvai.paths_strategies (name) on UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT paths_strategies_academias_pkey PRIMARY KEY (path_name, strategy_name, academia_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_strategies_academias_academia_name_index on nirvai.paths_strategies_academias (academia_name) INCLUDE (academia_name);
  CREATE INDEX paths_strategies_academias_path_name_index on nirvai.paths_strategies_academias (path_name) INCLUDE (path_name);
  CREATE INDEX paths_strategies_academias_strategy_name_index on nirvai.paths_strategies_academias (path_name) INCLUDE (strategy_name);
EOSQL
