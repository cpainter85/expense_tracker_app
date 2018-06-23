FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs tzdata
RUN mkdir /expenses_tracker_app

WORKDIR /expenses_tracker_app
COPY Gemfile /expenses_tracker_app/Gemfile
COPY Gemfile.lock /expenses_tracker_app/Gemfile.lock

RUN bundle install

COPY . /expenses_tracker_app