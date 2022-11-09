# @see https://github.com/plv8/plv8/blob/r3.1/platforms/Docker/bullseye/14.5/Dockerfile
# @see https://github.com/sibedge-llc/plv8-dockerfiles/blob/master/ubuntu/Dockerfile

FROM sibedge/postgres-plv8:15.0-3.1.4 AS plv8_build

EXPOSE 5432
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY docker-entrypoint-initdb.d/ docker-entrypoint-initdb.d/
USER postgres
