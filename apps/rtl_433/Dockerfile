FROM docker.io/library/alpine:3.21 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ADD https://github.com/merbanan/rtl_433/archive/${VERSION}.tar.gz /tmp/rtl_433.tar.gz

RUN apk add --no-cache --update cmake build-base librtlsdr-dev libusb-dev bash
WORKDIR /build
RUN tar -zxvf /tmp/rtl_433.tar.gz --strip-components=1
RUN mkdir out && cd out && cmake .. && make -j$(nproc) && make install

FROM docker.io/library/python:3.12-alpine

RUN \
    apk add --no-cache --update \
    libusb \
    librtlsdr \
    catatonit \
    && \
    pip install paho-mqtt

COPY --from=builder /usr/local/bin/rtl_433 /app/rtl_433
COPY --from=builder /build/examples/rtl_433_mqtt_hass.py /app/rtl_433_mqtt_hass.py

COPY ./apps/rtl_433/entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/merbanan/rtl_433"
