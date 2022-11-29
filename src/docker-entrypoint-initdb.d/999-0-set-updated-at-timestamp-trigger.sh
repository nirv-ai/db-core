#!/usr/bin/env bash

# @see https://www.postgresql.org/docs/current/plpgsql-trigger.html
# @see https://github.com/plv8/plv8/blob/r3.1/docs/FUNCTIONS.md
# @see https://github.com/plv8/plv8/blob/r3.1/doc/plv8.md

set -e

## triggers cannot be schema qualified
## only the resourceson which they operate
USE_SCHEMA="${USE_SCHEMA:-$DEFAULT_DB}"
USE_DB="${USE_DB:-$DEFAULT_DB}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$USE_DB" <<-EOSQL
  CREATE OR REPLACE FUNCTION $USE_SCHEMA.set_updated_at() RETURNS TRIGGER AS \$$
    BEGIN
      NEW.updated_at := current_timestamp;
      RETURN NEW;
    END;
  \$$ LANGUAGE plpgsql;

  -- TODO: convert these to an array & loop
  CREATE or replace TRIGGER PLAYERS_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.players
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER PATHS_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.paths
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER ACTIONS_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.actions
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER ACADEMIAS_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.academias
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER DISCIPLINES_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.disciplines
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER INCENTIVES_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.incentives
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER SKILLS_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.skills
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();

  CREATE or replace TRIGGER PATHS_STRATEGIES_set_updated_at
  BEFORE UPDATE ON $USE_SCHEMA.paths_strategies
  FOR EACH ROW
  EXECUTE FUNCTION $USE_SCHEMA.set_updated_at();
EOSQL
