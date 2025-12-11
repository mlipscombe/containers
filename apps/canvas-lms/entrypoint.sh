#!/usr/bin/env bash
set -eo pipefail

echo "Running database setup..."
rake db:initial_setup || true

echo "Generating brand configs..."
rake brand_configs:generate_and_upload_all || true

exec /sbin/tini -- "$@"
