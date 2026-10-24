# syntax=docker/dockerfile:1

ARG BASE_IMAGE=ghcr.io/cloudnative-pg/postgresql
ARG POSTGRES_VERSION=18.6

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
        amd64) sha256="6adc4c390c61109af337c5d5c15239623d6fc8b89e972625de04f52a5771cebf" ;; \
        arm64) sha256="54843473cbad144812be0437bc708233087c7823018700ffb99a2fb92d1466bb" ;; \
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
