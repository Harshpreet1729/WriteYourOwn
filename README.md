# WriteYourOwn

WriteYourOwn is a Django-based writing platform where users can sign up, create and manage articles, and track writing output (article count and word count) from a personalized dashboard.

The app is designed for both local development and production deployment (Railway), with flexible email provider support through `django-allauth` + `django-anymail`.

## Features

- Email-first authentication with custom user model (`email` as login field)
- Signup/login/account flows powered by `django-allauth`
- Article CRUD (create, update, delete) with ownership checks
- Per-user article list with pagination
- Search support on article titles (PostgreSQL full-text search)
- Automatic word count calculation from article content
- Customizable admin URL via environment variable (`ADMIN_URL`)
- Production-ready static file serving with WhiteNoise
- Email delivery via Mailjet API or Mailgun API

## Tech Stack

- Python 3.13
- Django 6
- PostgreSQL
- django-allauth
- django-anymail
- Gunicorn
- WhiteNoise
- Docker + Docker Compose
- Tailwind CSS (frontend styling assets)
- Pytest + Playwright (test tooling)

## Project Structure

```text
app/                    # Main app (models, views, URLs, admin)
djangoproject/          # Project settings and root URL config
templates/              # Django templates
static/                 # Static assets
tests/                  # Test suite (pytest + playwright)
Dockerfile
docker-compose.yml
start-django.sh
```

## Quick Start (Poetry)

### 1. Clone and install

```bash
git clone https://github.com/Harshpreet1729/WriteYourOwn.git
cd WriteYourOwn
poetry install
```

### 2. Set environment variables

Create environment variables in your shell (or in your host environment). At minimum:

```env
ENV_STATE=dev
DEBUG=True
SECRET_KEY=change-me
DATABASE_URL=sqlite:///db.sqlite3
ALLOWED_HOSTS=127.0.0.1,localhost
```

### 3. Run migrations and start server

```bash
poetry run python manage.py migrate
poetry run python manage.py runserver
```

App runs at `http://127.0.0.1:8000`.

## Quick Start (Docker)

This project includes a local Docker setup using Postgres.

```bash
docker compose up --build
```

The startup script automatically runs:

- `python manage.py collectstatic --no-input`
- `python manage.py migrate`
- Django dev server (or Gunicorn when `ENV_STATE=production`)

## Environment Variables

### Core

- `ENV_STATE`: `dev` or `production`
- `DEBUG`: `True` / `False`
- `SECRET_KEY`: Django secret key
- `DATABASE_URL`: Database DSN (`postgresql://...` in production)
- `ALLOWED_HOSTS`: Comma-separated hosts
- `CSRF_TRUSTED_ORIGINS`: Optional comma-separated origins
- `RAILWAY_PUBLIC_DOMAIN`: Railway domain auto-added to hosts/origins
- `ADMIN_URL`: Custom admin path segment (for example `notadmin123`)

### Email

- `EMAIL_PROVIDER`: `mailjet`, `mailgun`, or fallback/custom backend
- `EMAIL_FAIL_SILENTLY`: `False` recommended in production
- `EMAIL_TIMEOUT`: API timeout in seconds (default 8)

Mailjet:

- `MAILJET_API_KEY`
- `MAILJET_SECRET_KEY`
- `MAILJET_SENDER_EMAIL` (must be verified in Mailjet)

Mailgun:

- `MAILGUN_API_KEY`
- `MAILGUN_EMAIL`
- `MAILGUN_SENDER_DOMAIN` (optional but recommended)

## Railway Deployment Notes

1. Set `DATABASE_URL` from Railway Postgres using variable reference:
   - `DATABASE_URL=${{Postgres-<service>.DATABASE_URL}}`
2. Set production env vars (`ENV_STATE=production`, `DEBUG=False`, etc.).
3. Set a custom `ADMIN_URL` to avoid exposing `/admin/`.
4. Configure email provider variables (Mailjet or Mailgun).
5. After first deploy, update Django Site record so emails stop showing `example.com`:

```bash
python manage.py shell -c "from django.contrib.sites.models import Site; Site.objects.update_or_create(id=1, defaults={'domain':'your-domain.up.railway.app','name':'WriteYourOwn'})"
```

## Running Tests

```bash
poetry run pytest
```

Playwright-based tests may require browser installation:

```bash
poetry run playwright install --with-deps
```

## Common Issues

- `UnknownSchemeError: Scheme '://' is unknown`:
  `DATABASE_URL` is malformed. Use a valid `postgresql://...` URL or Railway variable reference.
- Confirmation email says `example.com`:
  update `django_site` record (`Site id=1`) in the production database.
- Mail sent locally but not in production:
  verify sender identity and provider credentials; keep `EMAIL_FAIL_SILENTLY=False` to surface real errors.

## Author

- Harshpreet1729
