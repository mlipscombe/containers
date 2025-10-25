FROM cgr.dev/chainguard/rust:latest-dev@sha256:1054b7fcf20afb1d639f001592bdc9d5214c2cd204b296c61f21abcb91414e82 as builder

ARG VERSION

WORKDIR /app

RUN \
    git clone https://github.com/redlib-org/redlib.git /app && cd /app && git checkout "${VERSION}" && \
    cargo build --release

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:0d1673dd55e8b7535fea5191c8337f0c18f46d55ed9020b9dcc1a2e17c550680

# trunk-ignore(hadolint/DL3018)
RUN apk update && \
    apk add --no-cache \
    libgcc \
    tini \
    wget

USER nonroot

COPY --from=builder /app/target/release/redlib /app/redlib

WORKDIR /app

EXPOSE 8080

HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider --quiet http://localhost:8080/settings || exit 1

CMD ["tini", "--", "/app/redlib", "--address", "0.0.0.0"]
