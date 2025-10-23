#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install
yarn install

# Build and precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run database migrations
bundle exec rails db:migrate