#!/usr/bin/env bash
# bin/render-build.sh

set -o errexit

echo "🔧 Installing dependencies..."
bundle install

echo "🗄️  Setting up database..."
bundle exec rails db:create RAILS_ENV=production || true
bundle exec rails db:migrate RAILS_ENV=production

echo "📄 Ensuring Swagger documentation is updated..."
ls -la swagger/v1/swagger.yaml || echo "Swagger file not found!"

echo "✅ Build complete!"
