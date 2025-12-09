#!/usr/bin/env bash
set -euo pipefail

for file in /usr/src/nginx/{,**/}*.erb; do
  if [ -f "$file" ]; then
    # don't overwrite an existing destination file
    if [ ! -e "${file%.*}" ]; then
      erb -T- "$file" > "${file%.*}"
      echo "${file%.*}: generated."
    else
      >&2 echo "${file%.*}: SKIPPED! refusing to overwrite existing file."
    fi
  fi
done

ln -sf /proc/self/fd/1 /usr/src/app/log/production.log

exec sudo -E /usr/sbin/nginx -c /usr/src/nginx/nginx.conf
