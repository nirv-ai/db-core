#!/usr/bin/env bash

set -e

TABLE_NAME=paths_academias
TABLE_COMMENT='junction table between paths and academias'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    academia_name TEXT REFERENCES nirvai.academias (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,

    CONSTRAINT paths_academias_pkey PRIMARY KEY (academia_name, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_academias_academia_name_index on nirvai.paths_academias (academia_name) INCLUDE (academia_name);
  CREATE INDEX paths_academias_path_name_index on nirvai.paths_academias (path_name) INCLUDE (path_name);
EOSQL
