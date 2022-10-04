#!/bin/sh

bundle check || bundle install

yarn install

exec /sbin/tini -- "$@"
