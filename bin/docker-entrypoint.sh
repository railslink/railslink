#!/bin/sh

# remove the server.pid
if [ -f $APP_DIR/tmp/pids/server.pid ]; then
  echo "---- REMOVING pid from $APP_DIR ----"
  rm $APP_DIR/tmp/pids/server.pid
fi

bundle check || bundle install

exec /sbin/tini -- "$@"
