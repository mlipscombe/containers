#!/bin/sh

set -eu

pidfile="/var/run/rsyslogd.pid"
rm -f "${pidfile}"

exec /usr/sbin/rsyslogd -n -f /config/rsyslog.conf -i "${pidfile}" $@
