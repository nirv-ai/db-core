#!/usr/bin/env bash

# @see https://www.postgresql.org/docs/current/sql-createview.html
# ^ implicitly-created CTE's name cannot be schema-qualified.

set -e

VIEW_NAME=v_skills_optimal
VIEW_COMMENT='view of optimal skills records generated by checking existence of certain junction records'
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE OR REPLACE VIEW $USE_SCHEMA.$VIEW_NAME as (
    select * from $USE_SCHEMA.skills a
    where exists (
          select * from $USE_SCHEMA.paths_skills ps
            where ps.skill_name = a.name
        )
  );

  comment on view $USE_SCHEMA.$VIEW_NAME is '$VIEW_COMMENT';
EOSQL
