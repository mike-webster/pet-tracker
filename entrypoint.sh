#!/bin/sh

log() {
    echo '---- : ' $1
}

log 'executing custom entrypoint script'

log 'database init'
rake db:create db:migrate

log 'starting app'
bundle exec puma -C "config/puma.rb" "config.ru"