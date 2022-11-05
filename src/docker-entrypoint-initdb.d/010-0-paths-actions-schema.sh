#!/usr/bin/env bash

set -e

TABLE_NAME=paths_actions
TABLE_COMMENT='junction table between paths and actions'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    actions_name TEXT REFERENCES nirvai.actions (name) ON UPDATE CASCADE ON DELETE CASCADE,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT paths_actions_pkey PRIMARY KEY (actions_name, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_actions_actions_name_index on nirvai.paths_actions (actions_name) INCLUDE (path_name);
  CREATE INDEX paths_actions_path_name_index on nirvai.paths_actions (path_name) INCLUDE (actions_name);
EOSQL
