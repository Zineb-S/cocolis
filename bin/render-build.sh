#!/usr/bin/env bash
# exit on error
set -o errexit

#  the existing database
bundle exec rake db:drop

# Create the database
bundle exec rake db:create

# Run migrations
bundle exec rake db:migrate

# Seed the database
bundle exec rake db:seed

# Install dependencies
bundle install

# Precompile assets
bundle exec rake assets:precompile

# Clean up old assets
bundle exec rake assets:clean
