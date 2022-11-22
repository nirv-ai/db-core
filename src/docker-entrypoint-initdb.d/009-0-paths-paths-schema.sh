#!/usr/bin/env bash

set -e

TABLE_NAME=paths_paths
TABLE_COMMENT='junction table between paths and paths (i.e related paths)'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,
    path_name_related TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT paths_paths_pkey PRIMARY KEY (path_name, path_name_related)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_paths_path_name_index on nirvai.paths_paths (path_name) INCLUDE (path_name);
  CREATE INDEX paths_paths_path_name_related_index on nirvai.paths_paths (path_name_related) INCLUDE (path_name_related);
EOSQL
