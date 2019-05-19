
@test "checking connect & execute sql: postgres-server" {
  run docker run --rm -it \
    --link postgresql_client:db \
    -e POSTGRESQL_HOST=db \
    -e POSTGRESQL_DATABASE=mydb \
    -e POSTGRESQL_USERNAME=myuser \
    -e POSTGRESQL_PASSWORD=mypass \
    madharjan/docker-postgresql-client:9.5 \
    -P tuples_only -c 'select user from user;'
  [ "$status" -eq 0 ]
}
