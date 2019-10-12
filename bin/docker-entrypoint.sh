#!/bin/sh

# remove the server.pid
#

bundle check || bundle install

exec /sbin/tini -- "$@"
