FROM python:3.9-slim as builder
LABEL maintainer="soxxes"

RUN pip3 install virtualenv

RUN mkdir -p /code/service
WORKDIR /code/service

COPY requirements.txt /code/service
COPY deps_python.sh /code
RUN /code/deps_python.sh

FROM python:3.9-slim
LABEL maintainer="soxxes"

RUN mkdir -p /code/service
WORKDIR /code/service

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/code/python_env/bin
ENV PYTHONPATH=/code/service

COPY --from=builder /code/python_env /code/python_env
COPY --from=builder /code/service/ /code/service
COPY entrypoint.sh /code
COPY database /code/service/database
COPY logic /code/service/logic
COPY models /code/service/models
COPY rest /code/service/rest
COPY schemas /code/service/schemas
COPY static /code/service/static
COPY templates /code/service/templates
COPY helo-server.py /code/service

EXPOSE 5000
ENTRYPOINT ["/code/entrypoint.sh"]
CMD ["run"]
