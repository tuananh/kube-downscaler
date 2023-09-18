FROM cgr.dev/chainguard/python:latest-dev as builder

WORKDIR /app

RUN pip3 install poetry

COPY poetry.lock /
COPY pyproject.toml /

RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-dev --no-ansi

FROM cgr.dev/chainguard/python:latest

WORKDIR /app

# copy pre-built packages to this image
COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages

# now copy the actual code we will execute (poetry install above was just for dependencies)
COPY kube_downscaler /app/kube_downscaler

ARG VERSION=dev

RUN sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" /kube_downscaler/__init__.py

ENTRYPOINT ["python3", "-m", "kube_downscaler"]