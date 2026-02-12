import os

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "djangoproject.settings")

from djangoproject.wsgi import application as app
