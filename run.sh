#!/usr/bin/env bash

mode=${1:-auto} 

docker build -t otel-demo:latest --build-arg mode=${mode} . && \
echo "starting container..." && docker run -d --rm --name otel-demo otel-demo:latest && sleep 3 && \
echo "rolling dice..."
for count in 1 2 3 4 5
do
    docker exec -it otel-demo curl http://127.0.0.1:5000/rolldice && echo
done
echo "telemetry logs (ctrl+c to exit):" && sleep 3 && \
if ! [ -x "$(command -v jq)" ]; then
    docker logs --follow otel-demo
else
    docker logs --follow otel-demo | jq -R "fromjson? | . "
fi
docker stop otel-demo