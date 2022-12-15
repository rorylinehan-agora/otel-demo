FROM python:3.10
SHELL ["/bin/bash", "-c"]

ARG mode=auto

RUN mkdir /otel-demo
WORKDIR /otel-demo
RUN python3 -m venv . && \
    source ./bin/activate && \
    pip install --upgrade pip
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD ${mode}.py ./app.py
CMD [ "flask", "run" ]