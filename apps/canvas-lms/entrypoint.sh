#!/usr/bin/env bash

generate_temp_key() {
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32
}

if [[ -z "${CANVAS_ENCRYPTION_KEY}" ]]; then
    echo "WARNING: CANVAS_ENCRYPTION_KEY is not set. Using a temporary, randomly generated 32-character key. Do NOT use this in production."
    CANVAS_ENCRYPTION_KEY="$(generate_temp_key)"
    export CANVAS_ENCRYPTION_KEY
fi

if [[ -z "${CANVAS_JWT_ENCRYPTION_KEY}" ]]; then
    echo "WARNING: CANVAS_JWT_ENCRYPTION_KEY is not set. Using a temporary, randomly generated 32-character key. Do NOT use this in production."
    CANVAS_JWT_ENCRYPTION_KEY="$(generate_temp_key)"
    export CANVAS_JWT_ENCRYPTION_KEY
fi

if [[ -z "${CANVAS_LTI_SIGNING_SECRET}" ]]; then
    echo "WARNING: CANVAS_LTI_SIGNING_SECRET is not set. Using a temporary, randomly generated 32-character key. Do NOT use this in production."
    CANVAS_LTI_SIGNING_SECRET="$(generate_temp_key)"
    export CANVAS_LTI_SIGNING_SECRET
fi


#echo "Running database setup..."
rake db:initial_setup

echo "Generating brand configs..."
rake brand_configs:generate_and_upload_all

echo "Starting Canvas LMS..."
exec /sbin/tini -- "$@"
