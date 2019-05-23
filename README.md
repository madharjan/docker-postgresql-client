# docker-postgresql-client

[![Build Status](https://travis-ci.com/madharjan/docker-postgresql-client.svg?branch=master)](https://travis-ci.com/madharjan/docker-postgresql-client)
[![Layers](https://images.microbadger.com/badges/image/madharjan/docker-postgresql-client.svg)](http://microbadger.com/images/madharjan/docker-postgresql-client)

Docker container with PostgreSQL Client based on [gliderlabs/alpine](https://github.com/gliderlabs/docker-alpine/)

## Features

* Bats [bats-core/bats-core](https://github.com/bats-core/bats-core) based test cases

## PostgreSQL Client 9.5 (docker-postgresql-client)

### Environment

| Variable             | Default      | Example        |
|----------------------|--------------|----------------|
| POSTGRESQL_HOST      |              | 192.168.1.1    |
| POSTGRESQL_PORT      | 5432         | 1235           |
| POSTGRESQL_DATABASE  | postgres     | mydb           |
| POSTGRESQL_USERNAME  | postgres     | myuser         |
| POSTGRESQL_PASSWORD  |              | mypass         |

## Build

```bash
# clone project
git clone https://github.com/madharjan/docker-postgresql-client
cd docker-postgresql-client


# build
make

# tests
make run
make test

# clean
make clean
```

## Run

### Postgres Server (docker-postgresql)

```bash
# stop & remove previous instances
docker stop postgresql
docker rm postgresql
# run container
docker run -d \
  -e POSTGRESQL_PASSWORD=mypass \
  --name postgresql \
  madharjan/docker-postgresql:9.5
```

### Postgres Client (docker-postgresql-client)

```bash
# psql console
docker run --rm -it \
  --link postgresql:db \
  -e POSTGRESQL_HOST=db \
  -e POSTGRESQL_PASSWORD=mypass \
  madharjan/docker-postgresql-client:9.5

# psql script
docker run --rm -it \
  --link postgresql:db \
  -e POSTGRESQL_HOST=db \
  -e POSTGRESQL_PASSWORD=mypass \
  madharjan/docker-postgresql-client:9.5 \
  -c 'select user from user'
```

### Cleanup

```bash
docker stop postgresql
docker rm postgresql
```
