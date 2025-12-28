#!/bin/sh
set -e

echo "Checking database connectivity..."
until python - <<'PY'
import os, sys
import psycopg
url = os.environ.get("DATABASE_URL")
try:
    with psycopg.connect(url, connect_timeout=3):
        pass
except Exception:
    import traceback
    traceback.print_exc()
    sys.exit(1)
PY
do
  echo "Waiting for Postgres..."
  sleep 2
done

python manage.py migrate
python manage.py collectstatic --noinput
exec gunicorn plane_api.wsgi:application --bind 0.0.0.0:8000
