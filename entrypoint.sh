#!/bin/sh
echo 'waiting for db'
#  ./wait.sh db:3306 -t 30 -- echo 'db ready'
# for some reason this isn't working
sleep 10

echo 'database init'
#   rake db:create db:migrate

echo 'starting app'
bundle exec puma -C "config/puma.rb" "config.ru"