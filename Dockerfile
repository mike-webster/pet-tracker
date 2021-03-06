FROM ruby:2.5.5-alpine

WORKDIR /pet-tracker
ENV APP_NAME=pet-tracker
ENV RAILS_ENV=development

RUN apk update && apk add --no-cache \
  bash \
  less \
  freetds \
  mariadb-client \
  mariadb-dev \
  mysql-client \
  libsass-dev \
  libc6-compat \
  libsass

ENV LD_LIBRARY_PATH=/lib64

RUN apk add --no-cache \
  alpine-sdk \
  freetds-dev \
  git \
  libxml2-dev \
  libxslt-dev \
  yarn


COPY . .

RUN bundle install --jobs=4
RUN bundle exec rake test:info
RUN RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000
# ENTRYPOINT ["./entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]