#!/usr/bin/env bash
set -euo pipefail

# Apply environment-based config overrides into Canvas YAML configs
ruby /usr/src/app/env_config_merge.rb

# Continue with the default command
exec "$@"
