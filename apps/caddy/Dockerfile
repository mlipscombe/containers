# syntax=docker/dockerfile:1

ARG VERSION
FROM caddy:${VERSION}-builder AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/abiosoft/caddy-yaml \
    --with github.com/mholt/caddy-l4/modules/l4proxy \
    --with github.com/mholt/caddy-l4/modules/l4tls \
    --with github.com/mholt/caddy-l4/modules/l4proxyprotocol
FROM caddy:${VERSION}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
