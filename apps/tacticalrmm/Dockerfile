# creates python virtual env
FROM python:3.11.8-slim AS CREATE_VENV_STAGE

ARG DEBIAN_FRONTEND=noninteractive

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# # set env variables
ENV VIRTUAL_ENV=/opt/venv
ENV TACTICAL_DIR=/opt/tactical
ENV TACTICAL_TMP_DIR=/tmp/tactical
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
FROM python:3.11.8-slim AS GET_SCRIPTS_STAGE

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    git clone https://github.com/amidaware/community-scripts.git /community-scripts

# runtime image
FROM python:3.11.8-slim

# set env variables
ENV VIRTUAL_ENV=/opt/venv
ENV TACTICAL_DIR=/opt/tactical
ENV TACTICAL_TMP_DIR=/tmp/tactical
ENV TACTICAL_READY_FILE=${TACTICAL_DIR}/tmp/tactical.ready
ENV TACTICAL_USER=tactical
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

# copy files from repo
COPY --from=CREATE_VENV_STAGE /build/api/tacticalrmm ${TACTICAL_TMP_DIR}/api
COPY --from=GET_SCRIPTS_STAGE /community-scripts ${TACTICAL_TMP_DIR}/community-scripts

# copy go install from build stage
COPY --from=CREATE_VENV_STAGE ${VIRTUAL_ENV} ${VIRTUAL_ENV}

# install deps
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends rsync weasyprint && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 "${TACTICAL_USER}" && \
    useradd -M -d "${TACTICAL_DIR}" -s /bin/bash -u 1000 -g 1000 "${TACTICAL_USER}"

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

# docker init
COPY ./apps/tacticalrmm/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR ${TACTICAL_DIR}/api

EXPOSE 8080 4443 8383
