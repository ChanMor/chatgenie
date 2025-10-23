#!/usr/bin/env bash

set -o errexit

echo "Installing Ruby gems..."
bundle install

echo "Installing Node.js packages with Yarn..."
yarn install --frozen-lockfile # Use --frozen-lockfile for CI/CD

echo "Precompiling assets (this will run yarn build internally)..."
bin/rails assets:precompile

echo "Cleaning old assets..."
bin/rails assets:clean

echo "Running database migrations..."
bin/rails db:migrate

echo "Build process completed successfully!"