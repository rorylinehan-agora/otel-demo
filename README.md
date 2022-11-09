# OpenTelemetry Python app example

## Overview

This is a self-contained proof of concept implemented using [this page](https://opentelemetry.io/docs/instrumentation/python/getting-started/)

## Usage

* Automatic instrumentation (default): `./run.sh auto`
* Manual: `./run.sh manual`
* Metrics: `./run.sh metrics`

When the logs are shown, the traces will be displayed immediately. You'll need to wait for about 60 seconds for telemetry metrics to come through.

In an actual environment, the exporters would be configured to expose via HTTP (rather than the console),
with some collection software scraping the information for downstream processing.
