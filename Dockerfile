FROM python:3.10
SHELL ["/bin/bash", "-c"]

ARG mode=auto
ARG nrlicense

ENV NRLICENSE=${nrlicense}

RUN mkdir /otel-demo
WORKDIR /otel-demo
RUN python3 -m venv . && \
    source ./bin/activate && \
    pip install --upgrade pip
ADD requirements.txt .
RUN pip install -r requirements.txt
RUN newrelic-admin generate-config $NRLICENSE newrelic.ini
ENV NEW_RELIC_CONFIG_FILE=newrelic.ini
ADD ${mode}.py ./app.py
CMD [ "newrelic-admin", "run-program", "flask", "run" ]