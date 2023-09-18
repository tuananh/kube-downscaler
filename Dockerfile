FROM cgr.dev/chainguard/python:latest-dev as builder

WORKDIR /home/nonroot/app

RUN pip3 install poetry
RUN python -m venv ./venv

COPY poetry.lock /home/nonroot/app
COPY pyproject.toml /home/nonroot/app

RUN . ./venv/bin/activate && /home/nonroot/.local/bin/poetry install --only main --no-root

COPY kube_downscaler /home/nonroot/app/kube_downscaler
# ARG VERSION=dev
# RUN sed -i "s/__version__ = .*/__version__ = '${VERSION}'/" /home/nonroot/app/kube_downscaler/__init__.py

FROM cgr.dev/chainguard/python:latest

WORKDIR /home/nonroot/app

COPY --from=builder /home/nonroot/app/.venv .venv
COPY --from=builder /home/nonroot/app/kube_downscaler /home/nonroot/app/kube_downscaler

RUN . ./venv/bin/activate

ENTRYPOINT ["python3", "-m", "kube_downscaler"]
