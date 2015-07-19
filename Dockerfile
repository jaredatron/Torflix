FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

ENV DATABASE_URL postgres://postgres@db:5432/torflix

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

RUN mkdir /app
ADD . /app
WORKDIR /app







