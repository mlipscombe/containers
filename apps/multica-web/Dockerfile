# syntax=docker/dockerfile:1

FROM docker.io/library/node:24-alpine AS builder

ARG VERSION

ENV NEXT_PUBLIC_API_URL="" \
    NEXT_PUBLIC_GOOGLE_CLIENT_ID="" \
    NEXT_PUBLIC_WS_URL="" \
    REMOTE_API_URL="http://backend:8080" \
    STANDALONE="true"

RUN apk add --no-cache git

RUN corepack enable && corepack prepare pnpm@10.28.2 --activate

WORKDIR /src

RUN git clone --depth 1 --branch "${VERSION}" https://github.com/multica-ai/multica.git .

COPY ./overrides/ /tmp/overrides/

RUN grep -F 'apiBaseUrl={process.env.NEXT_PUBLIC_API_URL}' /src/apps/web/components/web-providers.tsx \
    && grep -F 'const remoteApiUrl = process.env.REMOTE_API_URL || "http://localhost:8080";' /src/apps/web/next.config.ts \
    && cp -R /tmp/overrides/. /src/ \
    && pnpm install --frozen-lockfile \
    && pnpm --filter @multica/web build

FROM docker.io/library/node:24-alpine AS runner

RUN apk add --no-cache catatonit

WORKDIR /app

ENV HOME="/config" \
    HOSTNAME="0.0.0.0" \
    NODE_ENV="production" \
    PORT="3000"

RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 --ingroup nodejs nextjs \
    && mkdir -p /config

COPY --from=builder --chown=nextjs:nodejs /src/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /src/apps/web/.next/static ./apps/web/.next/static
COPY --from=builder --chown=nextjs:nodejs /src/apps/web/public ./apps/web/public
COPY --chown=nextjs:nodejs ./entrypoint.sh /entrypoint.sh

RUN ln -sf /config/runtime-config.js /app/apps/web/public/runtime-config.js \
    && chmod 755 /entrypoint.sh \
    && chown -R nextjs:nodejs /app /config

USER nextjs
VOLUME ["/config"]

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:3000/runtime-config.js | grep -q "__MULTICA_RUNTIME_CONFIG__" || exit 1

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
