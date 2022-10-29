#!/usr/bin/env bash

set -e

TABLE_NAME=paths
TABLE_COMMENT='paths are a set of activities, actions, skills'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    name text PRIMARY KEY,
    about text DEFAULT '',
    incentives text DEFAULT '',
    disciplines text DEFAULT '',
    academia text DEFAULT '',
    skills text DEFAULT '',
    strategy text DEFAULT '',
    child_paths text DEFAULT '',
    display_name text DEFAULT ''
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';
  comment on column $TABLE_NAME.name is 'paths name, once created CANNOT be changed';
  comment on column $TABLE_NAME.incentives is 'reasons for a player to implement a path';
  comment on column $TABLE_NAME.disciplines is 'overarching fields of study';
  comment on column $TABLE_NAME.academia is 'recommended level of education';
  comment on column $TABLE_NAME.skills is 'set of skills required for for success';
  comment on column $TABLE_NAME.about is 'description of path';
  comment on column $TABLE_NAME.strategy is 'recommended approach for success';
  comment on column $TABLE_NAME.child_paths is 'todo: remove this and make it a foreign field';
  comment on column $TABLE_NAME.display_name is 'a secondary name, as we dont allow changing paths.name';

EOSQL
