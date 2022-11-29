#!/usr/bin/env bash

set -e

TABLE_NAME=paths_paths
TABLE_COMMENT='junction table between paths and paths (i.e related paths)'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    path_name_related TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,

    CONSTRAINT paths_paths_pkey PRIMARY KEY (path_name, path_name_related)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_paths_path_name_index on nirvai.paths_paths (path_name) INCLUDE (path_name);
  CREATE INDEX paths_paths_path_name_related_index on nirvai.paths_paths (path_name_related) INCLUDE (path_name_related);
EOSQL
