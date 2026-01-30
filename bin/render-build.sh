#!/usr/bin/env bash
# bin/render-build.sh

set -o errexit

echo "🔧 Installing dependencies..."
bundle install

echo "🗄️  Setting up database..."
bundle exec rails db:create RAILS_ENV=production || true
bundle exec rails db:migrate RAILS_ENV=production

echo "📄 Ensuring Swagger documentation is updated..."
echo "📋 Current swagger.yaml servers configuration:"
head -15 swagger/v1/swagger.yaml | grep -A 5 "servers:"
echo "📁 File permissions:"
ls -la swagger/v1/swagger.yaml || echo "Swagger file not found!"

echo "🧹 Clearing Rails cache..."
bundle exec rails tmp:clear RAILS_ENV=production || true

echo "✅ Build complete!"
