FROM docker.io/library/alpine:3.21.6 AS builder
ARG VERSION

ADD https://github.com/merbanan/rtl_433/archive/${VERSION}.tar.gz /tmp/rtl_433.tar.gz

WORKDIR /build
RUN tar -zxvf /tmp/rtl_433.tar.gz --strip-components=1

FROM docker.io/library/python:3.13-alpine3.21

RUN pip install paho-mqtt \
    && apk add --no-cache --update \
    catatonit

COPY --from=builder /build/examples/rtl_433_mqtt_hass.py /app/rtl_433_mqtt_hass.py

COPY ./entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
