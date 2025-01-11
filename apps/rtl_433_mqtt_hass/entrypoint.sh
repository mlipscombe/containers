#!/bin/sh
#shellcheck disable=SC2086

set -e

exec /usr/local/bin/python \
    "/app/rtl_433_mqtt_hass.py" \
    "$@"
