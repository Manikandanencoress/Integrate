#!/usr/bin/env bash

source $HOME/.rvm/scripts/rvm && source .rvmrc

# install bundler if necessary
gem list --local bundler | grep bundler || gem install bundler || exit 1

# debugging info
echo USER=$USER && ruby --version && which ruby && which bundle

# conditionally install project gems from Gemfile
bundle check || bundle install || exit 1


set -e # exit if any of these things fail

bundle exec rake db:migrate
bundle exec rake db:test:prepare
bundle exec rake cruise
autotag create ci
bundle exec rake deploy:staging[$(autotag list ci | tail -n1 | awk '{ print $1 }')] #deploy to staging!