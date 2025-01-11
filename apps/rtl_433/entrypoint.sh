#!/bin/sh
#shellcheck disable=SC2086

exec \
    /app/rtl_433 \
        "$@"
