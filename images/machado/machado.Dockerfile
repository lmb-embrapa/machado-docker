FROM ubuntu:bionic

ARG MACHADO_SOURCE
ARG USER
ARG UID

ENV PYTHONUNBUFFERED 1

RUN useradd -m ${USER} -u ${UID}
RUN adduser ${USER} sudo
RUN mkdir /etc/sudoers.d
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}

RUN apt-get update
RUN apt-get install -y locales

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y apt-utils vim curl apache2 apache2-utils git sudo
RUN apt-get -y install python3 libapache2-mod-wsgi-py3
RUN ln /usr/bin/python3 /usr/bin/python
RUN apt-get -y install python3-pip
RUN ln /usr/bin/pip3 /usr/bin/pip
RUN pip install --upgrade pip

RUN pip install git+${MACHADO_SOURCE}
RUN pip install git+https://github.com/django-haystack/django-haystack
RUN pip install 'elasticsearch>=5,<6'

RUN mkdir /opt/machado 

RUN mkdir /opt/machado/config
COPY ./settings.py.sample /opt/machado/config
COPY ./django.conf.sample /opt/machado/config

RUN mkdir /opt/machado/bin
COPY ./build.sh /opt/machado/bin
RUN chmod a+x /opt/machado/bin/build.sh
COPY ./wait-for-it.sh /opt/machado/bin
RUN chmod a+x /opt/machado/bin/wait-for-it.sh

RUN mkdir /machado
WORKDIR /machado

EXPOSE 80

ENTRYPOINT /opt/machado/bin/build.sh
