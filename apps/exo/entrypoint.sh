#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    /app/bin/exo --disable-tui --data "${EXO_DATA:-/data}" \
        --listen-port "${EXO_LISTEN_PORT:-5000}" \
        --node-port "${EXO_NODE_PORT:-5001}" \
        --broadcast-port "${EXO_BROADCAST_PORT:-5002}" \
        --node-id $( [ -z "$NODE_ID" ] && NODE_ID=$(uuidgen); echo $NODE_ID ) \
        "$@"
