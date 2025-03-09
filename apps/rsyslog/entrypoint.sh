#!/usr/sh

set -eu

pidfile="/var/run/rsyslogd.pid"
rm -f "${pidfile}"

exec /usr/sbin/rsyslogd -n -f /config/rsyslogd.conf -i "${pidfile}" $@
