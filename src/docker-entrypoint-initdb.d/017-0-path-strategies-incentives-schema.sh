#!/usr/bin/env bash

set -e

TABLE_NAME=paths_strategies_incentives
TABLE_COMMENT='junction table between paths, strategies and incentives'

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DEFAULT_DB" <<-EOSQL
  CREATE TABLE IF NOT EXISTS $DEFAULT_DB.$TABLE_NAME (
    created_at TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    path_name TEXT references nirvai.paths (name) on UPDATE CASCADE ON DELETE CASCADE,
    incentive_name TEXT REFERENCES nirvai.incentives (name) ON UPDATE CASCADE ON DELETE CASCADE,
    strategy_name TEXT references nirvai.strategies (name) on UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT paths_strategies_incentives_pkey PRIMARY KEY (path_name, strategy_name, incentive_name)
  );

  comment on table $TABLE_NAME is '$TABLE_COMMENT';

  CREATE INDEX paths_strategies_incentives_incentive_name_index on nirvai.paths_strategies_incentives (incentive_name) INCLUDE (incentive_name);
  CREATE INDEX paths_strategies_incentives_path_name_index on nirvai.paths_strategies_incentives (path_name) INCLUDE (path_name);
  CREATE INDEX paths_strategies_incentives_strategy_name_index on nirvai.paths_strategies_incentives (path_name) INCLUDE (strategy_name);
EOSQL
