FROM python:3.13.5-bullseye
ENV PYTHONUNBUFFERED=1

RUN apt update
RUN apt install gettext -y
RUN mkdir /code

WORKDIR /code

RUN pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry install --no-root

COPY . .

EXPOSE 8000

ENTRYPOINT [ "/code/start-django.sh" ]