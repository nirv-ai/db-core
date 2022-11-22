#!/usr/bin/env bash

set -e

# @see https://www.postgresql.org/docs/current/collation.html#COLLATION-NONDETERMINISTIC
# @see https://postgresql.verite.pro/blog/2019/10/14/nondeterministic-collations.html

## on linux: `locale -a` to see available locales

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  -- can be used across all locales & regions
  -- primary ignores accents & case
  CREATE COLLATION IF NOT EXISTS anymatch (
    provider = icu,
    locale = '@colStrength=primary',
    deterministic = false
  );
EOSQL
