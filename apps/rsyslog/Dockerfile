ARG VERSION
FROM	alpine:3.21.3

RUN	apk --no-cache update  \
    && apk add --no-cache \
    catatonit \
    ca-certificates \
    tzdata \
    rsyslog \
    rsyslog-elasticsearch \
    rsyslog-hiredis \
    rsyslog-pgsql \
    rsyslog-mysql \
    rsyslog-mmjsonparse \
    rsyslog-mmutf8fix \
    rsyslog-tls

COPY ./apps/rsyslog/files/ /
COPY ./apps/rsyslog/entrypoint.sh /entrypoint.sh

VOLUME /var/run/rsyslog/dev
VOLUME /config

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

EXPOSE 514/tcp
EXPOSE 514/udp
EXPOSE 6514/tcp
