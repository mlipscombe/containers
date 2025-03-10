FROM cgr.dev/chainguard/rust:latest-dev@sha256:dcff5aeb77a252981d77c071e2412efac0140e855a17e301aecc5fdd44d1bf3e as builder

ARG VERSION

WORKDIR /app

# RUN \
#   git clone --depth 1 --branch "v${VERSION}" -c advice.detachedHead=false https://github.com/redlib-org/redlib.git /app && \
#   cargo build --release

RUN \
    git clone https://github.com/redlib-org/redlib.git /app && cd /app && git checkout "${VERSION}" && \
    cargo build --release

FROM cgr.dev/chainguard/wolfi-base:latest@sha256:4f12c90f259bd273ed698660bc983053c5f4d2d2617beb0d481d4ec43d7cbbbd

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
