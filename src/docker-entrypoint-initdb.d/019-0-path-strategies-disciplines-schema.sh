#!/usr/bin/env bash

set -e

TABLE_NAME=paths_strategies_disciplines
TABLE_COMMENT='junction table between paths, strategies and disciplines'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT references nirvai.paths (name) on UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    strategy_name TEXT NOT NULL collate anymatch,
    discipline_name TEXT REFERENCES nirvai.disciplines (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    CONSTRAINT paths_strategies_disciplines_pkey PRIMARY KEY (path_name, strategy_name, discipline_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_strategies_disciplines_discipline_name_index on nirvai.paths_strategies_disciplines (discipline_name) INCLUDE (discipline_name);
  CREATE INDEX paths_strategies_disciplines_path_name_index on nirvai.paths_strategies_disciplines (path_name) INCLUDE (path_name);
  CREATE INDEX paths_strategies_disciplines_strategy_name_index on nirvai.paths_strategies_disciplines (strategy_name) INCLUDE (strategy_name);
EOSQL
