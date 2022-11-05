#!/usr/bin/env bash

set -e

TABLE_NAME=paths_academia
TABLE_COMMENT='junction table between paths and academia'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    academia_name TEXT REFERENCES nirvai.academia (name) ON UPDATE CASCADE ON DELETE CASCADE,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT paths_academia_pkey PRIMARY KEY (academia_name, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_academia_academia_name_index on nirvai.paths_academia (academia_name) INCLUDE (path_name);
  CREATE INDEX paths_academia_path_name_index on nirvai.paths_academia (path_name) INCLUDE (academia_name);
EOSQL
