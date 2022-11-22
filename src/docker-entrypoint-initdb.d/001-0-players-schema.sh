#!/usr/bin/env bash
# TODO: need to create player 'nirvai' which owns all default records
## ^ i.e. you also need to create junction records
set -e

TABLE_NAME=players
TABLE_COMMENT='players are users that have not requested account deletion'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    callsign text PRIMARY KEY collate anymatch,
    email text NOT NULL UNIQUE collate anymatch,
    password text NOT NULL,
    first text DEFAULT '',
    avatar text DEFAULT 'https://placekitten.com/g/200/200',
    about text DEFAULT '',
    last text DEFAULT ''
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.callsign is 'players name';
  comment on column $TABLE_NAME.email is 'players email';
  comment on column $TABLE_NAME.password is 'players password, PLZ fkn use pgcrypto when modifying';
  comment on column $TABLE_NAME.avatar is 'a url to an image';
  comment on column $TABLE_NAME.first is 'players first name';
  comment on column $TABLE_NAME.last is 'players last name';
  comment on column $TABLE_NAME.about is 'players about me description';

EOSQL
