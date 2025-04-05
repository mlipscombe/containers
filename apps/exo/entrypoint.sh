#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    /app/bin/exo --disable-tui --node-id $( [ -z "$NODE_ID" ] && NODE_ID=$(uuidgen); echo $NODE_ID ) \
        "$@"
