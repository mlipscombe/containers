# syntax=docker/dockerfile:1

FROM docker.io/library/golang:1.26-alpine AS builder

ARG VERSION

RUN apk add --no-cache git

WORKDIR /src

RUN git clone --depth 1 --branch "${VERSION}" https://github.com/multica-ai/multica.git .

RUN cd server \
    && go mod download \
    && CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o /out/server ./cmd/server \
    && CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -X main.version=${VERSION}" -o /out/multica ./cmd/multica \
    && CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o /out/migrate ./cmd/migrate

FROM docker.io/library/alpine:3.21

ARG VERSION

ENV APP_ENV="production" \
    LOCAL_UPLOAD_DIR="/config/uploads" \
    PORT="8080"

RUN apk add --no-cache \
        ca-certificates \
        catatonit \
        tzdata \
        wget \
    && mkdir -p /app /config \
    && chown nobody:nogroup /config

COPY --from=builder /out/server /app/server
COPY --from=builder /out/multica /app/multica
COPY --from=builder /out/migrate /app/migrate
COPY --from=builder /src/server/migrations /app/migrations
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod 755 /app/server /app/multica /app/migrate /entrypoint.sh

USER nobody:nogroup
WORKDIR /app
VOLUME ["/config"]

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:8080/health || exit 1

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
