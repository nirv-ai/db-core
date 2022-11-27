#!/usr/bin/env bash

# @see https://www.postgresql.org/docs/current/sql-createview.html
# ^ implicitly-created CTE's name cannot be schema-qualified.

set -e

VIEW_NAME=v_actions_optimal
VIEW_COMMENT='view of optimal actions records generated by checking existence of certain junction records'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE OR REPLACE VIEW $DEFAULT_DB.$VIEW_NAME as (
    select * from $DEFAULT_DB.actions a
    where exists (
          select * from $DEFAULT_DB.paths_actions pa
            where pa.action_name = a.name
        )
  );

  comment on view $VIEW_NAME is '$VIEW_COMMENT';
EOSQL
