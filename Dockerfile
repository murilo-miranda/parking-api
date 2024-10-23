FROM ruby:3.2.3

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libpq-dev

WORKDIR /api

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .