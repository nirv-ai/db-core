# @see https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md
# @see https://github.com/plv8/plv8/blob/r3.1/platforms/Docker/bullseye/14.5/Dockerfile
# @see https://github.com/sibedge-llc/plv8-dockerfiles/blob/master/ubuntu/Dockerfile
# @see https://aws.amazon.com/blogs/database/postgresql-bi-directional-replication-using-pglogical/
FROM sibedge/postgres-plv8:15.0-3.1.4 AS plv8_build


RUN set -ex; \
  cat /etc/os-release

ENV TERM=xterm \
    LANG=en_US.utf8
# @see https://github.com/edenlabllc/alpine-postgre/blob/master/pglogical/Dockerfile
RUN set -ex && \
  postgresHome="$(getent passwd postgres)" && \
  postgresHome="$(echo "$postgresHome" | cut -d: -f6)" && \
  [ "$postgresHome" = '/var/lib/postgresql' ] && \
  mkdir -p "$postgresHome" && \
  chown -R postgres:postgres "$postgresHome"
# always use nocache option, runs apk update and rm -rf /var/cache/apk/*
# @see https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk
RUN set -ex; \
  apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/v3.10/community \
  bison \
  ca-certificates \
  coreutils \
  curl \
  dpkg-dev dpkg \
  flex \
  gcc \
  libc-dev \
  libedit-dev \
  libxml2-dev \
  libxslt-dev \
  make \
  openssl \
  openssl-dev \
  perl \
  postgresql-pglogical \
  tar \
  tzdata \
  util-linux-dev \
  zlib-dev

# @see https://github.com/2ndQuadrant/pglogical
ENV pg_audit_version=1.7.0
ENV pg_audit_tar_url=https://github.com/pgaudit/pgaudit/archive/${pg_audit_version}.tar.gz



RUN set -ex && \
  bash -c 'mkdir -p /tmp/pgaudit' && \
    cd /tmp/pgaudit && curl -L ${pg_audit_tar_url} | tar xz --strip 1
