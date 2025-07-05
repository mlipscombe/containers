# syntax=docker/dockerfile:1

ARG VERSION
FROM ghcr.io/cleanuparr/cleanuparr:${VERSION}

USER root

COPY . /

RUN mkdir -p /config/logs && \
    chown -R nobody:nogroup /app && \
    chown -R nobody:nogroup /config

USER nobody:nogroup

VOLUME ["/config"]

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
