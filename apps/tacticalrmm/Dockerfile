# creates python virtual env
FROM python:3.11.8-slim AS build

ARG DEBIAN_FRONTEND=noninteractive

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# # set env variables
ENV VIRTUAL_ENV=/opt/venv
ENV TACTICAL_BASE_DIR=/opt/tactical-base
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

ADD https://github.com/amidaware/tacticalrmm/archive/v${VERSION}.tar.gz /tmp/tacticalrmm.tar.gz
WORKDIR /build
RUN tar -zxvf /tmp/tacticalrmm.tar.gz --strip-components=1
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libc6-dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir setuptools wheel && \
    pip install --no-cache-dir -r api/tacticalrmm/requirements.txt

# pulls community scripts from git repo
FROM python:3.11.8-slim AS scripts

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    git clone https://github.com/amidaware/community-scripts.git /community-scripts

# runtime image
FROM python:3.11.8-slim

# set env variables
ENV VIRTUAL_ENV=/opt/venv
ENV TACTICAL_BASE_DIR=/opt/tactical-base
ENV TACTICAL_DIR=/opt/tactical
ENV TACTICAL_USER=tactical
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

# copy files from repo
COPY --from=build /build/api/tacticalrmm ${TACTICAL_BASE_DIR}/api
COPY --from=scripts /community-scripts ${TACTICAL_BASE_DIR}/community-scripts

RUN mkdir -p "${TACTICAL_DIR}" && \
    mkdir -p "${TACTICAL_BASE_DIR}/tmp" && \
    mkdir -p "${TACTICAL_BASE_DIR}/certs" && \
    mkdir -p "${TACTICAL_BASE_DIR}/reporting" && \
    mkdir -p "${TACTICAL_BASE_DIR}/reporting/assets" && \
    touch "${TACTICAL_BASE_DIR}/tmp/.initialized" && chown -R 1000:1000 "${TACTICAL_BASE_DIR}" && \
    touch "${TACTICAL_BASE_DIR}/certs/.initialized" && chown -R 1000:1000 "${TACTICAL_BASE_DIR}/certs" && \
    touch "${TACTICAL_BASE_DIR}/reporting" && chown -R 1000:1000 "${TACTICAL_BASE_DIR}/reporting" && \
    mkdir -p "${TACTICAL_BASE_DIR}/api/tacticalrmm/private/exe" && \
    mkdir -p "${TACTICAL_BASE_DIR}/api/tacticalrmm/private/log" && \
    touch "${TACTICAL_BASE_DIR}/api/tacticalrmm/private/log/django_debug.log"

# copy go install from build stage
COPY --from=build ${VIRTUAL_ENV} ${VIRTUAL_ENV}

# install deps
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends rsync weasyprint && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 "${TACTICAL_USER}" && \
    useradd -M -d "${TACTICAL_DIR}" -s /bin/bash -u 1000 -g 1000 "${TACTICAL_USER}" && \
    chown -R 1000:1000 "${TACTICAL_DIR}"

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

# docker init
WORKDIR ${TACTICAL_DIR}/api

RUN python manage.py create_uwsgi_conf

COPY ./apps/tacticalrmm/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080 4443 8383
