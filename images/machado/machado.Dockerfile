FROM ubuntu:bionic

ARG MACHADO_SOURCE
ARG USER
ARG UID

ENV PYTHONUNBUFFERED 1


RUN useradd -m ${USER} -u ${UID}
RUN adduser ${USER} sudo
RUN mkdir /etc/sudoers.d
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}

RUN apt-get update && \
        apt-get install -y locales

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y apt-utils
RUN apt-get install -y vim curl wget apache2 apache2-utils git sudo unzip python3 libapache2-mod-wsgi-py3 python3 libapache2-mod-wsgi-py3 python3-pip build-essential zlib1g-dev libpng-dev libgd-perl

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
RUN pip install --upgrade pip

RUN pip install git+${MACHADO_SOURCE}
RUN pip install git+https://github.com/django-haystack/django-haystack
RUN pip install 'elasticsearch>=5,<6'

RUN mkdir /machado && \
        chmod 777 /machado

RUN mkdir /opt/machado && \
        mkdir /opt/machado/config
COPY ./config/* /opt/machado/config/

RUN mkdir /opt/machado/bin
COPY ./build.sh /opt/machado/bin
RUN chmod a+x /opt/machado/bin/build.sh
COPY ./wait-for-it.sh /opt/machado/bin
RUN chmod a+x /opt/machado/bin/wait-for-it.sh

RUN wget https://github.com/GMOD/jbrowse/releases/download/1.16.9-release/JBrowse-1.16.9.zip && \
        unzip JBrowse-1.16.9.zip && \
        rm JBrowse-1.16.9.zip && \
        mv JBrowse-1.16.9 /var/www/html/jbrowse && \
        mkdir /var/www/html/jbrowse/data && \
        chown -R ${USER} /var/www/html/jbrowse

USER ${USER}

RUN cd /var/www/html/jbrowse && \
        chmod a+x setup.sh && \
        ./setup.sh

WORKDIR /machado

EXPOSE 80

ENTRYPOINT /opt/machado/bin/build.sh
