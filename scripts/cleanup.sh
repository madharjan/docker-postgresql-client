#!/bin/sh 
set -e

if [ "${DEBUG}" = true ]; then
  set -x
fi

rm -rf  /var/cache/apk/* 
rm -rf /tmp/*
rm -rf /build
