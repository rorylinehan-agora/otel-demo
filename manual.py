# These are the necessary import declarations
from opentelemetry import trace
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import SimpleSpanProcessor
from opentelemetry.exporter.jaeger.thrift import JaegerExporter

from random import randint
from flask import Flask, request

trace.set_tracer_provider(TracerProvider(resource = Resource.create({SERVICE_NAME: "trace_demo"})))
tracer = trace.get_tracer(__name__)
jaeger_exporter = JaegerExporter(
    # configure agent
    agent_host_name='jaeger',
    agent_port=6831,
    # optional: configure also collector
    # collector_endpoint='http://localhost:14268/api/traces?format=jaeger.thrift',
    # username=xxxx, # optional
    # password=xxxx, # optional
    # max_tag_value_length=None # optional
)
span_processor = SimpleSpanProcessor(jaeger_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

app = Flask(__name__)

@app.route("/rolldice")
def roll_dice():
    return str(do_roll())

def do_roll():
    # This creates a new span that's the child of the current one
    with tracer.start_as_current_span("do_roll") as rollspan:  
        res = randint(1, 6)
        rollspan.set_attribute("roll.value", res)
        with tracer.start_as_current_span("do_nested_roll") as nestedroll:
            nestedroll.set_attribute("nestedroll.value", res)
    return res

@app.route("/failrolldice")
def fail_roll_dice():
    return str(do_fail_roll())

def do_fail_roll():
    with tracer.start_as_current_span("do_fail_roll") as failrollspan:  
        res = randint(1, 6)
        failrollspan.set_attribute("failroll.value", res)
        raise ValueError