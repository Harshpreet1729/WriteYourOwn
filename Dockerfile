FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1

RUN apt update
RUN apt install gettext -y
RUN mkdir /code

RUN pip install --upgrade pip
COPY pyproject.toml poetry.lock ./
RUN pip install poetry && poetry export -f requirements.txt --without-hashes > requirements.txt
RUN pip install -r requirements.txt

WORKDIR /code

RUN pip install poetry

COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root
COPY . .

RUN poetry install --no-root

COPY . .

EXPOSE 8000

ENTRYPOINT [ "/code/start-django.sh" ]