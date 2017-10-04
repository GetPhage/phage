FROM ubuntu:14.04

FROM ruby:2.3.5
MAINTAINER romkey@romkey.com
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs \
  mdns-scan

RUN mkdir -p /app 
WORKDIR /app

COPY . /app
#COPY Gemfile Gemfile.lock ./ 

RUN gem install bundler --pre && bundle install --jobs 20 --retry 5

EXPOSE 3000

#ADD . $APP_HOME
