#!/usr/bin/env bash

set -e

TABLE_NAME=paths_strategies_skills
TABLE_COMMENT='junction table between paths, strategies and skills'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT references nirvai.paths (name) on UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    strategy_name TEXT NOT NULL collate anymatch,
    skill_name TEXT REFERENCES nirvai.skills (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    CONSTRAINT paths_strategies_skills_pkey PRIMARY KEY (path_name, strategy_name, skill_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_strategies_skills_skill_name_index on nirvai.paths_strategies_skills (skill_name) INCLUDE (skill_name);
  CREATE INDEX paths_strategies_skills_path_name_index on nirvai.paths_strategies_skills (path_name) INCLUDE (path_name);
  CREATE INDEX paths_strategies_skills_strategy_name_index on nirvai.paths_strategies_skills (strategy_name) INCLUDE (strategy_name);
EOSQL
