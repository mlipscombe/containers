#!/usr/sh

set -eu

pidfile="/var/run/rsyslogd.pid"
rm -f "${pidfile}"

exec rsyslogd -n -f /etc/rsyslogd.conf -i "${pidfile}" $@
