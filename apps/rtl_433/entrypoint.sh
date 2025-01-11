#!/usr/bin/env bash
#shellcheck disable=SC2086

/usr/local/bin/python \
    "/app/rtl_433_mqtt_hass.py" \
    ${RTL_433_MQTT_HASS_ARGS} &

/app/rtl_433 \
    ${RTL_433_ARGS} &

# Wait for the process to finish
wait $!

exit $?
