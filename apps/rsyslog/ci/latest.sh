#!/usr/bin/env bash

# renovate: datasource=docker depName=alpine
ALPINE_VERSION=3.21.3

ALPINE_VERSION_TRIMMED=${ALPINE_VERSION%.*}

version=$(curl -sX GET "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION_TRIMMED}/main/x86_64/APKINDEX.tar.gz" | tar -xzO | grep -aA1 "P:rsyslog$" | grep -o "V:.*" | cut -d':' -f2)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
