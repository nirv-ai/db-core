#!/usr/bin/env bash

set -e

TABLE_NAME=incentives
TABLE_COMMENT='incentives are motivations for joining a path'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"
A_SEARCH_COL='name_search'
A_SEARCH_COL_SOURCE="name"
B_SEARCH_COL='about_search'
B_SEARCH_COL_SOURCE="about"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_dB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    name text PRIMARY KEY collate anymatch,
    created_by text DEFAULT 'nirvai' collate anymatch,
    about text DEFAULT '' collate anymatch,
    display_name text DEFAULT '' collate anymatch,
    $A_SEARCH_COL tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce($A_SEARCH_COL_SOURCE, ''))) STORED,
    $B_SEARCH_COL tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce($B_SEARCH_COL_SOURCE, ''))) STORED
  );

  CREATE INDEX ${TABLE_NAME}_${A_SEARCH_COL}_index ON $TABLE_NAME USING GIN ($A_SEARCH_COL);
  CREATE INDEX ${TABLE_NAME}_${B_SEARCH_COL}_index  ON $TABLE_NAME USING GIN ($B_SEARCH_COL);


  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'incentives name, once created CANNOT be changed';
  comment on column $TABLE_NAME.about is 'description of incentive';
  comment on column $TABLE_NAME.created_by is 'player that created the incentive, nirvai by default';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing incentives.name';

EOSQL
