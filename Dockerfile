FROM ruby:2.4.4-alpine

RUN apk add --update --no-cache \
  build-base \
  less \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  postgresql-client \
  postgresql-dev \
  tini \
  tzdata

WORKDIR /usr/src/app

COPY . ./

EXPOSE 3000

ENTRYPOINT ["/usr/src/app/bin/docker-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
