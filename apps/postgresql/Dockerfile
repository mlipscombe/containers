# syntax=docker/dockerfile:1

ARG BASE_IMAGE=ghcr.io/cloudnative-pg/postgresql
ARG POSTGRES_VERSION=18.4

FROM docker.io/library/debian:trixie-slim AS pg-textsearch
ARG TARGETARCH
ARG PG_TEXTSEARCH_VERSION
ARG PG_MAJOR=18
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    set -eux; \
    case "${TARGETARCH}" in \
        amd64) sha256="4a8291b44c2c700ef71f9230e14fbe434dc0f8b20bca13eb31b049367911de38" ;; \
        arm64) sha256="9590a2c604372d6ff05a8012ffd8f2a0caa74a8a6c81917ea5d12f3d0dad6ec6" ;; \
        *) echo "unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    artifact="pg-textsearch-v${PG_TEXTSEARCH_VERSION}-pg${PG_MAJOR}-${TARGETARCH}.zip"; \
    curl -fsSLo "/tmp/${artifact}" "https://github.com/timescale/pg_textsearch/releases/download/v${PG_TEXTSEARCH_VERSION}/${artifact}"; \
    echo "${sha256}  /tmp/${artifact}" | sha256sum -c -; \
    unzip -q "/tmp/${artifact}" -d /tmp/pg_textsearch; \
    dpkg-deb -x /tmp/pg_textsearch/*.deb /tmp/rootfs

FROM ${BASE_IMAGE}:${POSTGRES_VERSION}
ARG PG_MAJOR=18

USER root
COPY --from=pg-textsearch /tmp/rootfs/usr/lib/postgresql/${PG_MAJOR}/lib/pg_textsearch.so /usr/lib/postgresql/${PG_MAJOR}/lib/pg_textsearch.so
COPY --from=pg-textsearch /tmp/rootfs/usr/share/postgresql/${PG_MAJOR}/extension/pg_textsearch* /usr/share/postgresql/${PG_MAJOR}/extension/
RUN \
    chown root:root /usr/lib/postgresql/${PG_MAJOR}/lib/pg_textsearch.so /usr/share/postgresql/${PG_MAJOR}/extension/pg_textsearch* \
    && chmod 755 /usr/lib/postgresql/${PG_MAJOR}/lib/pg_textsearch.so \
    && chmod 644 /usr/share/postgresql/${PG_MAJOR}/extension/pg_textsearch*

USER 26
