FROM python:3.13-slim



ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gettext \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /code

RUN pip install --upgrade pip

# 1. Install Poetry explicitly
RUN pip install poetry

# 2. Copy dependency files first (for Docker caching)
COPY pyproject.toml poetry.lock ./

# 3. CRITICAL FIX: Configure poetry to NOT use a virtualenv
#    and install dependencies globally.
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

# 4. Copy the startup script and make it executable
COPY start-django.sh /code/start-django.sh
RUN chmod +x /code/start-django.sh

# 5. Copy the rest of the application
COPY . .

EXPOSE 8000

ENTRYPOINT ["/code/start-django.sh"]