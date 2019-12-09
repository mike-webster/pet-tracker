FROM ruby:2.5.5-alpine

RUN apk update && apk add --no-cache \
  bash \
  less \
  freetds \
  mariadb-client \
  mariadb-dev \
  mysql-client 

RUN apk add --no-cache \
  alpine-sdk \
  freetds-dev \
  git \
  libxml2-dev \
  libxslt-dev \
  yarn

WORKDIR /pet-tracker

COPY . .

RUN gem install nokogiri -v '1.10.7' --source 'https://rubygems.org/'

RUN bundle install

EXPOSE 3000
ENTRYPOINT ["bundle", "exec", "puma", "-C", "config/puma.rb"]