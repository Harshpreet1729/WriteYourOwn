#!/bin/sh
set -e

python manage.py collectstatic --no-input
python manage.py migrate

if [ "$ENV_STATE" = "production" ]; then
    gunicorn djangoproject.wsgi:application \
        --bind 0.0.0.0:8000 \
        --workers ${GUNICORN_WORKERS:-3}
else
    python manage.py runserver 0.0.0.0:8000
fi
