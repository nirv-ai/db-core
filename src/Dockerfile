FROM postgres:15.0 as basepostgres

EXPOSE 5432

COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY docker-entrypoint-initdb.d/ docker-entrypoint-initdb.d/
