FROM ruby:2.7.1

RUN mkdir /app
ENV HOME /app
WORKDIR $HOME
ADD ./slackbot/Gemfile $HOME/Gemfile
ADD ./slackbot/Gemfile.lock $HOME/Gemfile.lock

RUN apt-get update
RUN apt-get install -y libgmp-dev

RUN bundle install