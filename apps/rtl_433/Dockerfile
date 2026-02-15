FROM docker.io/library/alpine:3.21.6 AS builder
ARG VERSION

ADD https://github.com/merbanan/rtl_433/archive/${VERSION}.tar.gz /tmp/rtl_433.tar.gz

RUN apk add --no-cache --update cmake build-base librtlsdr-dev openssl-dev libusb-dev bash
WORKDIR /build
RUN tar -zxvf /tmp/rtl_433.tar.gz --strip-components=1
RUN mkdir out && cd out && cmake -DENABLE_OPENSSL=ON .. && make -j$(nproc) && make install

FROM docker.io/library/alpine:3.22

RUN \
    apk add --no-cache --update \
    libusb \
    librtlsdr \
    tzdata \
    openssl \
    catatonit

COPY --from=builder /usr/local/bin/rtl_433 /app/rtl_433

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /app
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
