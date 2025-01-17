FROM docker.io/nvidia/cuda:12.6.3-runtime-ubuntu24.04

ARG TARGETARCH
ARG VERSION
ARG CHANNEL

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="DontWarn"

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

USER root
WORKDIR /app

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3 \
    python3-dev \
    python3-venv \
    python3-pip \
    catatonit \
    && python3 -m venv /app \
    && . /app/bin/activate \
    && /app/bin/python3 -m pip install --no-cache-dir -U setuptools wheel \
    && /app/bin/python3 -m pip install --no-cache-dir torch \
    && \
    /app/bin/python3 -m pip install --no-cache-dir \
    --extra-index-url https://www.piwheels.org/simple \
    "wyoming-faster-whisper @ https://github.com/rhasspy/wyoming-faster-whisper/archive/refs/tags/v${VERSION}.tar.gz" \
    && \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean

COPY ./apps/wyoming-faster-whisper/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
