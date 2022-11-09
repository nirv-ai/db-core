#!/usr/bin/env bash

# @see https://www.postgresql.org/docs/current/plpgsql-trigger.html
# @see https://github.com/plv8/plv8/blob/r3.1/docs/FUNCTIONS.md
# @see https://github.com/plv8/plv8/blob/r3.1/doc/plv8.md

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER AS \$$
    BEGIN
      NEW.updated_at := current_timestamp;
      RETURN NEW;
    END;
  \$$ LANGUAGE plpgsql;

  -- TODO: convert these to an array & loop
  CREATE or replace TRIGGER set_updated_at
  BEFORE UPDATE ON nirvai.players
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

  CREATE or replace TRIGGER set_updated_at
  BEFORE UPDATE ON nirvai.players
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

  CREATE or replace TRIGGER set_updated_at
  BEFORE UPDATE ON nirvai.actions
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

  CREATE or replace TRIGGER set_updated_at
  BEFORE UPDATE ON nirvai.actions
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();
EOSQL
