FROM ruby:2.5.5-alpine

WORKDIR /pet-tracker
ENV APP_NAME=pet-tracker

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


COPY . .
RUN bundle install --jobs=4
RUN bundle exec rake assets:precompile

EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]