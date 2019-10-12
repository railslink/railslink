#!/bin/sh

# remove the server.pid
rm /usr/src/app/tmp/pids/server.pid

bundle check || bundle install

exec /sbin/tini -- "$@"
