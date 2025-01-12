FROM docker.io/library/alpine:3.21 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ADD https://github.com/mlipscombe/boiler-mate/archive/${VERSION}.tar.gz /tmp/boiler-mate.tar.gz

WORKDIR /build
RUN tar -zxvf /tmp/boiler-mate.tar.gz --strip-components=1
ENV CGO_ENABLED 0
RUN go mod download
RUN go build -o boiler-mate

FROM scratch

COPY --from=builder /build/boiler-mate /boiler-mate

USER nobody:nogroup
WORKDIR /
EXPOSE 2112
ENV BOILER_MATE_METRICS="0.0.0.0:2112"

ENTRYPOINT ["/boiler-mate"]

LABEL org.opencontainers.image.source="https://github.com/mlipscombe/boiler-mate"
