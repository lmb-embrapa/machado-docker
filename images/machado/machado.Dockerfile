FROM python:3

ARG MACHADO_SOURCE

ENV PYTHONUNBUFFERED 1

RUN pip install git+${MACHADO_SOURCE}
RUN pip install git+https://github.com/django-haystack/django-haystack
RUN pip install 'elasticsearch>=5,<6'

RUN mkdir /opt/machado 

RUN mkdir /opt/machado/config
COPY ./settings.py.sample /opt/machado/config

RUN mkdir /opt/machado/bin
COPY ./build.sh /opt/machado/bin
RUN chmod a+x /opt/machado/bin/build.sh
COPY ./wait-for-it.sh /opt/machado/bin
RUN chmod a+x /opt/machado/bin/wait-for-it.sh

RUN mkdir /machado
WORKDIR /machado

ENTRYPOINT /opt/machado/bin/build.sh
