#!/usr/bin/env bash

set -e

TABLE_NAME=paths_incentives
TABLE_COMMENT='junction table between paths and incentives'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    incentive_name TEXT REFERENCES nirvai.incentives (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    path_name TEXT REFERENCES nirvai.paths (name) ON UPDATE CASCADE ON DELETE CASCADE collate anymatch,
    CONSTRAINT paths_incentives_pkey PRIMARY KEY (incentive_name, path_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_incentives_incentive_name_index on nirvai.paths_incentives (incentive_name) INCLUDE (incentive_name);
  CREATE INDEX paths_incentives_path_name_index on nirvai.paths_incentives (path_name) INCLUDE (path_name);
EOSQL
