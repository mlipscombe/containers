FROM nginxinc/nginx-unprivileged:1.27.3-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV PUBLIC_DIR /usr/share/nginx/html
ENV TACTICAL_DIR /opt/tactical
USER root

RUN deluser --remove-home nginx \
    && addgroup -S nginx -g 1000 \
    && adduser -S -G nginx -u 1000 nginx

RUN apk add --no-cache bash wget tar grep

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

RUN webtar="trmm-web-v${VERSION}.tar.gz" \
    && wget -q "https://github.com/amidaware/tacticalrmm-web/releases/download/v${VERSION}/${webtar}" -O /tmp/${webtar} \
    && tar -xzf /tmp/${webtar} -C ${PUBLIC_DIR} \
    && rm -f /tmp/${webtar}

RUN mv ${PUBLIC_DIR}/dist/* ${PUBLIC_DIR}
RUN rm -rf ${PUBLIC_DIR}/dist
RUN chown -R nginx:nginx /etc/nginx && chown -R nginx:nginx ${PUBLIC_DIR}

COPY ./apps/tacticalrmm-frontend/entrypoint.sh /docker-entrypoint.d/
COPY ./apps/tacticalrmm-frontend/files/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod +x /docker-entrypoint.d/entrypoint.sh

USER nginx

EXPOSE 8080
