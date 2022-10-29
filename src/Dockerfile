FROM postgres:15.0 as basepostgres

EXPOSE 5432

COPY docker-entrypoint-initdb.d/ docker-entrypoint-initdb.d/
