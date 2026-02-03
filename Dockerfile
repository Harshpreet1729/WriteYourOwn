FROM python:3.13-slim

ENV PYTHONUNBUFFERED=1

RUN apt-get update \
 && apt-get install -y gettext \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /code

RUN pip install --upgrade pip

COPY pyproject.toml poetry.lock ./
RUN pip install poetry && poetry install --no-root

COPY start-django.sh /code/start-django.sh
COPY . .

EXPOSE 8000

ENTRYPOINT ["sh", "/code/start-django.sh"]
