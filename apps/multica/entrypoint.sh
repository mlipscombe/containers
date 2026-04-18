#!/bin/sh

set -eu

: "${LOCAL_UPLOAD_DIR:=/config/uploads}"

mkdir -p "${LOCAL_UPLOAD_DIR}"

./migrate up

exec ./server
