#!/bin/sh
set -e

exec \
    /app/rtl_433 \
        "$@"
