#!/usr/bin/env bash
#shellcheck disable=SC2086

# Adapted from https://raw.githubusercontent.com/amidaware/tacticalrmm/refs/heads/develop/docker/containers/tactical/entrypoint.sh

set -e

: "${PUID:=1000}"
: "${PGID:=1000}"
: "${SKIP_UWSGI_CONFIG:=0}"

# tactical-init
if [ "$1" = 'tactical-init' ]; then

  # copy container data to volume
  rsync -a --no-perms --no-owner --delete --exclude "tmp/*" --exclude "certs/*" --exclude="api/tacticalrmm/private/*" "${TACTICAL_TMP_DIR}/" "${TACTICAL_DIR}/"

  mkdir -p ${TACTICAL_DIR}/tmp
  mkdir -p ${TACTICAL_DIR}/certs
  mkdir -p ${TACTICAL_DIR}/reporting
  mkdir -p ${TACTICAL_DIR}/reporting/assets
  touch ${TACTICAL_DIR}/tmp/.initialized && chown -R 1000:1000 ${TACTICAL_DIR}
  touch ${TACTICAL_DIR}/certs/.initialized && chown -R 1000:1000 ${TACTICAL_DIR}/certs
  touch ${TACTICAL_DIR}/reporting && chown -R 1000:1000 ${TACTICAL_DIR}/reporting
  mkdir -p ${TACTICAL_DIR}/api/tacticalrmm/private/exe
  mkdir -p ${TACTICAL_DIR}/api/tacticalrmm/private/log
  touch ${TACTICAL_DIR}/api/tacticalrmm/private/log/django_debug.log

  # run migrations and init scripts
  python manage.py pre_update_tasks
  python manage.py migrate --no-input
  python manage.py generate_json_schemas
  python manage.py get_webtar_url >${TACTICAL_DIR}/tmp/web_tar_url
  python manage.py collectstatic --no-input
  python manage.py initial_db_setup
  python manage.py initial_mesh_setup
  python manage.py load_chocos
  python manage.py load_community_scripts
  python manage.py reload_nats
  python manage.py create_natsapi_conf

  if [ "$SKIP_UWSGI_CONFIG" = 0 ]; then
    python manage.py create_uwsgi_conf
  fi

  python manage.py create_installer_user
  python manage.py clear_redis_celery_locks
  python manage.py post_update_tasks

  # create super user
  echo "Creating dashboard user if it doesn't exist"
  echo "from accounts.models import User; User.objects.create_superuser('${TRMM_USER}', 'admin@example.com', '${TRMM_PASS}') if not User.objects.filter(username='${TRMM_USER}').exists() else 0;" | python manage.py shell

  # chown everything to tactical user
  echo "Updating permissions on files"
  chown -R "${PUID}":"${PGID}" "${TACTICAL_DIR}"

  exit 0
fi

# backend container
if [ "$1" = 'tactical-backend' ]; then
  exec uwsgi ${TACTICAL_DIR}/api/app.ini
fi

if [ "$1" = 'tactical-celery' ]; then
  exec celery -A tacticalrmm worker --autoscale=20,2 -l info
fi

if [ "$1" = 'tactical-celerybeat' ]; then
  test -f "${TACTICAL_DIR}/api/celerybeat.pid" && rm "${TACTICAL_DIR}/api/celerybeat.pid"
  exec celery -A tacticalrmm beat -l info
fi

# websocket container
if [ "$1" = 'tactical-websockets' ]; then
  export DJANGO_SETTINGS_MODULE=tacticalrmm.settings

  exec uvicorn --host 0.0.0.0 --port 8383 --forwarded-allow-ips='*' tacticalrmm.asgi:application
fi

echo "Unknown command $1... exiting."
exit 1
