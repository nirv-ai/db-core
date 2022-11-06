#!/usr/bin/env bash

set -e

TABLE_NAME=paths_paths
TABLE_COMMENT='junction table between paths and paths (i.e related paths)'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_x_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,
    path_y_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT paths_paths_pkey PRIMARY KEY (path_x_name, path_y_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_paths_paths_x_index on nirvai.paths_paths (path_x_name) INCLUDE (path_x_name);
  CREATE INDEX paths_paths_path_y_index on nirvai.paths_paths (path_y_name) INCLUDE (path_y_name);
EOSQL
