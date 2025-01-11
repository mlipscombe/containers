FROM docker.io/library/alpine:3.21 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ADD https://github.com/merbanan/rtl_433/archive/${VERSION}.tar.gz /tmp/rtl_433.tar.gz

WORKDIR /build
RUN tar -zxvf /tmp/rtl_433.tar.gz --strip-components=1

FROM docker.io/library/python:3.13-alpine

RUN pip install paho-mqtt

COPY --from=builder /build/examples/rtl_433_mqtt_hass.py /app/rtl_433_mqtt_hass.py

COPY ./apps/rtl_433_mqtt_hass/entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/merbanan/rtl_433"
