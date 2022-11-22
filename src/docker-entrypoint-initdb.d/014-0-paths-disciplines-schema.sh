#!/usr/bin/env bash

set -e

TABLE_NAME=paths_disciplines
TABLE_COMMENT='junction table between paths and disciplines'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    discipline_name TEXT REFERENCES nirvai.disciplines (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,

    CONSTRAINT paths_disciplines_pkey PRIMARY KEY (discipline_name, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_disciplines_discipline_name_index on nirvai.paths_disciplines (discipline_name) INCLUDE (discipline_name);
  CREATE INDEX paths_disciplines_path_name_index on nirvai.paths_disciplines (path_name) INCLUDE (path_name);
EOSQL
