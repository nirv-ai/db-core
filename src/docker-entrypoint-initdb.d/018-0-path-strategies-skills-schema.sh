#!/usr/bin/env bash

set -e

TABLE_NAME=paths_strategies_skills
TABLE_COMMENT='junction table between paths, strategies and skills'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT references nirvai.paths (name) on UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    skill_name TEXT REFERENCES nirvai.skills (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    strategy_name TEXT references nirvai.paths_strategies (name) on UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    CONSTRAINT paths_strategies_skills_pkey PRIMARY KEY (path_name, strategy_name, skill_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_strategies_skills_skill_name_index on nirvai.paths_strategies_skills (skill_name) INCLUDE (skill_name);
  CREATE INDEX paths_strategies_skills_path_name_index on nirvai.paths_strategies_skills (path_name) INCLUDE (path_name);
  CREATE INDEX paths_strategies_skills_strategy_name_index on nirvai.paths_strategies_skills (path_name) INCLUDE (strategy_name);
EOSQL
