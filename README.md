# db-core

- [NIRVAI racexp](https://github.com/orgs/nirv-ai/projects/6)

## handy vscode find replace

- replace - in strings with spaces without removing the preceding char
  - ([A-Za-z])-
  - $1
    - $1 contains a space after it

## SQL

```sql
-- get COST and TIME of executing a query
-- lower cost is better, who woulda thought
EXPLAIN ANALYZE SELECT * FROM medley LIMIT 100;
```

## submodule

- [git submodule docs](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [dbs](https://github.com/nirv-ai/dbs)
  - the opensource dbs repo, added as a submodule to keep it insync whenever appropriate changes need to be made
  - simply CD into dbs dir and git

## rancher-desktop

- [install docs](https://docs.rancherdesktop.io/getting-started/installation/#linux)
  - make sure you remove all docker stuff first, including ~/.docker and /etc/docker, /var/lib/docker

# postgres

## links

- [docker-library postgres](https://github.com/docker-library/postgres)
- [dockerize postgres](https://docs.docker.com/samples/postgresql_service/)
- [docker postgres readme](https://hub.docker.com/_/postgres/)

## TLDR

```sh
# grab the conf file from the base image
docker run -i --rm postgres:15.0 cat /usr/share/postgresql/postgresql.conf.sample > postgresql.conf
## @see https://hub.docker.com/_/postgres

# setup
# ^ check the initdb script, which provides sensible defaults
sudo chmod +x ./docker-entrypoint-initdb.d/000-runthisfile.sh

# create the volume
docker volume create nirvaidbcore

# build
## gennerally needed if you change any of the init files

## without compose
docker build -t nirvai:db-core .

## with compose
docker compose build

# start
## via docker run
docker run -d --rm \
  --name nirvai-db-core \
  -e PG_PASSWORD=postgres \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -e POSTGRES_DB=postgres \
  -e POSTGRES_HOST_AUTH_METHOD=scram-sha-256 \
  -e POSTGRES_INITDB_ARGS=--auth-host=scram-sha-256 \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_USER=postgres \
  -p 5432:5432 \
  nirvai:db-core

## via docker run with env file
  docker run -d --rm \
    --env-file=./.env \
    --name nirvai-db-core \
    -p 5432:5432 \
    nirvai:db-core

## via docker compose
docker compose up -d

## check check result
docker compose config

# confirm everything is +1
docker logs nirvpgfoss

# ssh to server
docker exec -it nirvai-db-core bash

# ssh to db
docker exec -it nirvai-db-core psql \
  -U postgres \
  -d postgres
```

## dbeaver

- nothing unusual; just create a new db connection and add info
