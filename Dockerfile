FROM python:3.10
SHELL ["/bin/bash", "-c"]

ARG mode=auto

RUN mkdir /otel-poc
WORKDIR /otel-poc
RUN python3 -m venv . && \
    source ./bin/activate && \
    pip install --upgrade pip
RUN pip install \
    flask\
    opentelemetry-distro
RUN opentelemetry-bootstrap -a install
ADD ${mode}.py ./app.py
CMD [ \
    "opentelemetry-instrument", \
    "--traces_exporter", "console", \
    "--metrics_exporter", "console", \
    "flask", "run" \
]