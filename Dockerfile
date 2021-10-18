FROM ruby:2.7.4-alpine

ENV APP_DIR /usr/src/app

RUN apk add --update --no-cache \
  bash \
  build-base \
  less \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  postgresql-client \
  postgresql-dev \
  tini \
  tzdata \
  yarn

WORKDIR $APP_DIR

COPY . ./

EXPOSE 3000

ENTRYPOINT ["/usr/src/app/bin/docker-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000", "-P", "/tmp/rails_server.pid"]
