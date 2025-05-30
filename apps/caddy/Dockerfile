# syntax=docker/dockerfile:1

ARG VERSION
FROM caddy:${VERSION}-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare --with github.com/abiosoft/caddy-yaml
FROM caddy:${VERSION}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
