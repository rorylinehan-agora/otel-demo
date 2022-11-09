#!/usr/bin/env bash
mode=$1
if [ "auto" = $mode ]; then
    docker build -t otel-poc-automatic:latest -f Dockerfile.automatic . && \
    echo "starting container..." && docker run -d --rm --name otel-auto otel-poc-automatic:latest && \
    sleep 3 && \
    echo "rolling dice..." && docker exec -it otel-auto curl http://127.0.0.1:5000/rolldice && echo && \
    echo "telemetry logs (ctrl+c after telemetry info is displayed):" && docker logs --follow otel-auto
    docker stop otel-auto
fi
#docker build -t otel-poc-manual:latest -f Dockerfile.manual .