#!/usr/bin/env bash
# This file is the entrypoint of the docker container.
# set -e

rm -rf tmp/pids
mkdir -p tmp/pids

bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

bundle exec foreman start
