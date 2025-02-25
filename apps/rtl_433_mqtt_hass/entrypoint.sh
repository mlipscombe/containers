#!/bin/sh
set -e

exec /usr/local/bin/python \
    "/app/rtl_433_mqtt_hass.py" \
    "$@"
