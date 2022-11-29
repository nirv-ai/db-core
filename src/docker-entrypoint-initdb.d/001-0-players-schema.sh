#!/usr/bin/env bash
# TODO: need to create player 'nirvai' which owns all default records
## ^ i.e. you also need to create junction records
set -e

TABLE_NAME=players
TABLE_COMMENT='players are users that have not requested account deletion'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"
A_SEARCH_COL='callsign_search'
A_SEARCH_COL_SOURCE="callsign"
B_SEARCH_COL='about_search'
B_SEARCH_COL_SOURCE="about"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $USE_SCHEMA.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    callsign text PRIMARY KEY collate anymatch,
    email text NOT NULL UNIQUE collate anymatch,
    password text NOT NULL,
    first text DEFAULT '' collate anymatch,
    avatar text DEFAULT 'https://placekitten.com/g/200/200',
    about text DEFAULT '' collate anymatch,
    last text DEFAULT '' collate anymatch,
    display_name text DEFAULT '' collate anymatch,
    $A_SEARCH_COL tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce($A_SEARCH_COL_SOURCE, ''))) STORED,
    $B_SEARCH_COL tsvector GENERATED ALWAYS AS (to_tsvector('english', coalesce($B_SEARCH_COL_SOURCE, ''))) STORED
  );

  CREATE INDEX ${TABLE_NAME}_${A_SEARCH_COL}_index ON $TABLE_NAME USING GIN ($A_SEARCH_COL);
  CREATE INDEX ${TABLE_NAME}_${B_SEARCH_COL}_index  ON $TABLE_NAME USING GIN ($B_SEARCH_COL);
  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.callsign is 'players name';
  comment on column $TABLE_NAME.email is 'players email';
  comment on column $TABLE_NAME.password is 'players password, PLZ fkn use pgcrypto when modifying';
  comment on column $TABLE_NAME.avatar is 'a url to an image';
  comment on column $TABLE_NAME.first is 'players first name';
  comment on column $TABLE_NAME.last is 'players last name';
  comment on column $TABLE_NAME.about is 'players about me description';

EOSQL
