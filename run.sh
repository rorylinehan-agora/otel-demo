#!/usr/bin/env bash

# bash run.sh manual $(az-secret read -e qa agora--hermes--newrelic-license-key)

mode=${1:-auto}
nrlicense=$2

docker network create --attachable oteldemo

# start jaeger
docker run --network oteldemo --hostname jaeger -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.40

docker build -t otel-demo:latest --build-arg mode=${mode} --build-arg nrlicense=${nrlicense} . && \
echo "starting container..." && docker run --network oteldemo -d --rm --name otel-demo otel-demo:latest && sleep 3 && \
echo "rolling dice..."
for count in 1 2 3 4 5
do
    docker exec -it otel-demo curl http://127.0.0.1:5000/rolldice && echo
done
echo "telemetry logs (ctrl+c to exit):" && sleep 3 && \
if ! [ -x "$(command -v jq)" ]; then
    docker logs --follow jaeger
else
    docker logs --follow jaeger | jq -R "fromjson? | . "
fi
# cleanup
docker stop otel-demo jaeger
docker rm jaeger
docker network rm oteldemo