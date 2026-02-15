FROM docker.io/nvidia/cuda:13.1.1-cudnn-runtime-ubuntu24.04

ARG VERSION

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive"

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
    "wyoming-faster-whisper @ https://github.com/rhasspy/wyoming-faster-whisper/archive/refs/tags/${VERSION}.tar.gz" \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && mkdir -p /config && chown nobody:nogroup -R /config

COPY ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENV HOME="/config"
ENV HF_HUB_CACH="/config/.cache"
ENV TEMP="/config/.temp"

WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
