FROM cgr.dev/chainguard/python:latest-dev as builder

WORKDIR /home/nonroot/app

RUN pip3 install poetry

COPY poetry.lock /home/nonroot/app
COPY pyproject.toml /home/nonroot/app

RUN /home/nonroot/.local/bin/poetry install \
    --no-interaction \
    --only main \
    --no-ansi \
    --no-root

COPY kube_downscaler /home/nonroot/app/kube_downscaler
# ARG VERSION=dev
# RUN sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" /home/nonroot/app/kube_downscaler/__init__.py

FROM cgr.dev/chainguard/python:latest

WORKDIR /home/nonroot/app

# copy pre-built packages to this image
COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages

# now copy the actual code we will execute (poetry install above was just for dependencies)
COPY --from=builder /home/nonroot/app/kube_downscaler /home/nonroot/app/kube_downscaler

ENTRYPOINT ["python3", "-m", "kube_downscaler"]