#!/usr/bin/env bash

set -e

TABLE_NAME=paths_skills
TABLE_COMMENT='junction table between paths and skills'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    skills_name TEXT REFERENCES nirvai.skills (name) ON UPDATE CASCADE ON DELETE CASCADE,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT paths_skills_pkey PRIMARY KEY (skills_name, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_skills_skills_name_index on nirvai.paths_skills (skills_name) INCLUDE (path_name);
  CREATE INDEX paths_skills_path_name_index on nirvai.paths_skills (path_name) INCLUDE (skills_name);
EOSQL
