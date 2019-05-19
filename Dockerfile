FROM gliderlabs/alpine:3.4
MAINTAINER Madhav Raj Maharjan <madhav.maharjan@gmail.com>

ARG VCS_REF
ARG POSTGRESQL_VERSION
ARG DEBUG=false

LABEL description="Docker container with Postgresql Client" os_version="Alpine 3.4" \
      org.label-schema.vcs-ref=${VCS_REF} org.label-schema.vcs-url="https://github.com/madharjan/docker-postgresql-client"

ENV HOME /root
ENV ALPINE_VERSION 3.4
ENV POSTGRESQL_VERSION ${POSTGRESQL_VERSION}

COPY ./psql.sh /

RUN apk update && \
    apk add bash postgresql-client && \
    rm -rf  /var/cache/apk/* \
    rm -rf /tmp/* && \
    chmod 755 /psql.sh

WORKDIR /root

ENTRYPOINT ["/psql.sh"]
