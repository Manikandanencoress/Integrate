#!/bin/bash

set -e

# stop postgres
launchctl unload -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

# This is only for development machines. Probably could be made a lot better.
sudo brew update

sudo chown -R $(whoami) /usr/local

# blow away default image's data directory
rm -rf /usr/local/var/postgres

brew remove postgresql
brew install postgresql

initdb -U milyoni --encoding=utf8 --locale=en_US /usr/local/var/postgres

# Make the launch agents
mkdir -p ~/Library/LaunchAgents

# start PG on restart
cp /usr/local/Cellar/postgresql/9.0.4/org.postgresql.postgres.plist ~/Library/LaunchAgents/

launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist