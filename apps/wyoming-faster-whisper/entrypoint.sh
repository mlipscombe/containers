#!/bin/sh
#shellcheck disable=SC2086

exec \
    /app/bin/python3 -m  wyoming_faster_whisper \
        --uri 'tcp://0.0.0.0:10300' \
        --data-dir /config \
        --download-dir /config \
        --model "${MODEL:-tiny-int8}" \
        --language "${LANGUAGE:-en}" \
        --device "${DEVICE:-cpu}" \
        "$@"
