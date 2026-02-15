ARG VERSION
FROM alpine:3.21.6

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

COPY ./defaults/ /
COPY ./entrypoint.sh /entrypoint.sh

VOLUME /var/run/rsyslog/dev
VOLUME /config

EXPOSE 514/tcp
EXPOSE 514/udp
EXPOSE 6514/tcp

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]
