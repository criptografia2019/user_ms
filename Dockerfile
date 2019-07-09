FROM ruby:2.5

RUN mkdir /users_ms
WORKDIR /users_ms

ADD Gemfile /users_ms/Gemfile
ADD Gemfile.lock /users_ms/Gemfile.lock

RUN bundle install
ADD . /users_ms

EXPOSE 3306
