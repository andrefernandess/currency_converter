#!/usr/bin/env bash
# bin/render-build.sh

set -o errexit

echo "🔧 Installing dependencies..."
bundle install

echo "🗄️  Setting up database..."
bundle exec rails db:create RAILS_ENV=production || true
bundle exec rails db:migrate RAILS_ENV=production

echo "✅ Build complete!"
