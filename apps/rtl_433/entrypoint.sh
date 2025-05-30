#!/bin/sh
set -e

# Check if no arguments are supplied
if [ $# -eq 0 ]; then
    echo "No arguments supplied. Showing help."
    set -- "-h"
fi

exec \
    /app/rtl_433 \
        "$@"
