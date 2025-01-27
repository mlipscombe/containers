#!/usr/bin/env bash
#shellcheck disable=SC2086

if [[ -z "${API_HOST}" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration - missing a required environment variable"
    [[ -z "${API_HOST}" ]]       && printf "\e[1;32m%-6s\e[m\n" "API_HOST: unset"
    exit 1
fi

echo "window._env_ = {PROD_URL: \"https://${API_HOST}\"}" > /dev/shm/env-config.js
