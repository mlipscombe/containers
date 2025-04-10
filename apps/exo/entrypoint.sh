#!/usr/bin/env bash
set -eo pipefail

EXO_DATA="${EXO_DATA:-/data}"
NODE_ID=$( [ -z "$NODE_ID" ] && NODE_ID=$(uuidgen); echo $NODE_ID )
HOME="${EXO_DATA}"
TRANSFORMERS_CACHE="${EXO_DATA}/transformers_cache"
mkdir -p "${TRANSFORMERS_CACHE}"

#shellcheck disable=SC2086
exec \
    /app/bin/python3 /app/bin/exo --disable-tui --data "${EXO_DATA}" \
        --listen-port "${EXO_LISTEN_PORT:-5000}" \
        --node-port "${EXO_NODE_PORT:-5001}" \
        --broadcast-port "${EXO_BROADCAST_PORT:-5002}" \
        --chatgpt-api-port "${EXO_CHATGPT_API_PORT:-5003}" \
        --node-id $( [ -z "$NODE_ID" ] && NODE_ID=$(uuidgen); echo $NODE_ID ) \
        "$@"
